import 'package:flutter/material.dart';
import 'package:localizacoes/features/localizacoes/data/repositories/repositorio_localizacoes.dart';
import 'package:localizacoes/features/localizacoes/models/localizacao.dart';
import 'package:localizacoes/features/localizacoes/presentation/widgets/item_localizacao.dart';

class TelaLocalizacoes extends StatefulWidget {
  const TelaLocalizacoes({super.key, required this.coletaAtiva});

  final bool coletaAtiva;

  @override
  State<TelaLocalizacoes> createState() => _TelaLocalizacoesState();
}

class _TelaLocalizacoesState extends State<TelaLocalizacoes> {
  final _repositorio = const RepositorioLocalizacoes();
  late Future<List<Localizacao>> _localizacoes = _repositorio.listarUltimas();

  void _atualizar() {
    setState(() {
      _localizacoes = _repositorio.listarUltimas();
    });
  }

  Future<void> _limpar() async {
    final aviso = widget.coletaAtiva
        ? '\n\nA coleta está ativa: novos registros continuarão sendo salvos.'
        : '';
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar histórico'),
        content: Text(
          'Todos os registros serão excluídos. Esta operação é permanente.'
          '$aviso',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Limpar histórico'),
          ),
        ],
      ),
    );
    if (confirmado != true) return;
    try {
      await _repositorio.excluirTodas();
      if (!mounted) return;
      _atualizar();
      _mostrarMensagem('Histórico limpo com sucesso.');
    } catch (erro) {
      if (!mounted) return;
      _mostrarMensagem('Não foi possível limpar o histórico: $erro');
    }
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            icon: const Icon(Icons.refresh),
            onPressed: _atualizar,
          ),
          IconButton(
            tooltip: 'Limpar histórico',
            icon: const Icon(Icons.delete_forever),
            onPressed: _limpar,
          ),
        ],
      ),
      body: FutureBuilder(
        future: _localizacoes,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao consultar o histórico: ${snapshot.error}'),
            );
          }
          final localizacoes = snapshot.requireData;
          if (localizacoes.isEmpty) {
            return const Center(child: Text('Nenhuma localização registrada.'));
          }
          return ListView.builder(
            itemCount: localizacoes.length,
            itemBuilder: (context, i) =>
                ItemLocalizacao(localizacao: localizacoes[i]),
          );
        },
      ),
    );
  }
}
