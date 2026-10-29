import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localizacoes/features/localizacoes/data/repositories/repositorio_localizacoes.dart';
import 'package:localizacoes/features/localizacoes/models/localizacao.dart';
import 'package:localizacoes/features/localizacoes/presentation/screens/tela_localizacoes.dart';
import 'package:localizacoes/features/localizacoes/presentation/screens/tela_mapa.dart';
import 'package:localizacoes/features/localizacoes/services/servico_localizacao.dart';

class TelaColeta extends StatefulWidget {
  const TelaColeta({super.key});

  @override
  State<TelaColeta> createState() => _TelaColetaState();
}

class _TelaColetaState extends State<TelaColeta> {
  final _servico = const ServicoLocalizacao();
  final _repositorio = const RepositorioLocalizacoes();
  StreamSubscription<void>? _assinatura;
  bool _ocupado = false;
  String _mensagem = 'Coleta parada.';

  Future<void> _iniciar() async {
    if (_ocupado || _assinatura != null) return;
    setState(() => _ocupado = true);
    final erro = await _verificarPermissoes();
    if (!mounted) return;
    if (erro == null) {
      _assinatura = _servico
          .posicoes()
          // asyncMap espera cada gravação terminar antes de tratar a próxima
          // posição, evitando gravações sobrepostas.
          .asyncMap(_salvar)
          .listen(null, onError: (Object e) => _informar('Erro na coleta: $e'));
    }
    setState(() {
      _ocupado = false;
      _mensagem = erro ?? 'Coleta ativa.';
    });
  }

  // Retorna uma orientação para o usuário quando a coleta não pode começar.
  Future<String?> _verificarPermissoes() async {
    try {
      if (!await _servico.gpsHabilitado()) {
        return 'Ative a localização (GPS) do aparelho e tente novamente.';
      }
      final permissao = await _servico.solicitarPermissao();
      if (permissao == LocationPermission.deniedForever) {
        return 'Permissão de localização bloqueada. Toque em "Configurações de '
            'permissão" e permita o acesso à localização.';
      }
      if (permissao != LocationPermission.whileInUse &&
          permissao != LocationPermission.always) {
        return 'Permissão de localização negada. A coleta depende dessa '
            'autorização.';
      }
      await _servico.solicitarPermissaoNotificacao();
      return null;
    } catch (erro) {
      return 'Não foi possível verificar a localização: $erro';
    }
  }

  Future<void> _salvar(Position posicao) {
    return _repositorio.inserir(
      Localizacao(
        latitude: posicao.latitude,
        longitude: posicao.longitude,
        precisao: posicao.accuracy,
        instante: posicao.timestamp,
      ),
    );
  }

  Future<void> _parar() async {
    final assinatura = _assinatura;
    if (_ocupado || assinatura == null) return;
    setState(() => _ocupado = true);
    await assinatura.cancel();
    if (!mounted) return;
    setState(() {
      _assinatura = null;
      _ocupado = false;
      _mensagem = 'Coleta parada.';
    });
  }

  Future<void> _abrirConfiguracoes() async {
    final abriu = await _servico.abrirConfiguracoes().catchError((_) => false);
    if (!abriu) _informar('Não foi possível abrir as configurações.');
  }

  void _informar(String mensagem) {
    if (mounted) setState(() => _mensagem = mensagem);
  }

  void _abrir(Widget tela) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => tela));
  }

  @override
  void dispose() {
    _assinatura?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ativa = _assinatura != null;
    return Scaffold(
      appBar: AppBar(title: const Text('Coleta de localização')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [
            Text(_mensagem),
            ElevatedButton(
              onPressed: ativa || _ocupado ? null : _iniciar,
              child: const Text('Iniciar coleta'),
            ),
            ElevatedButton(
              onPressed: !ativa || _ocupado ? null : _parar,
              child: const Text('Parar coleta'),
            ),
            ElevatedButton(
              onPressed: () => _abrir(TelaLocalizacoes(coletaAtiva: ativa)),
              child: const Text('Consultar histórico'),
            ),
            ElevatedButton(
              onPressed: () => _abrir(const TelaMapa()),
              child: const Text('Ver mapa'),
            ),
            ElevatedButton(
              onPressed: _abrirConfiguracoes,
              child: const Text('Configurações de permissão'),
            ),
          ],
        ),
      ),
    );
  }
}
