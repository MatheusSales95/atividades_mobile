import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:localizacoes/features/localizacoes/data/repositories/repositorio_localizacoes.dart';
import 'package:localizacoes/features/localizacoes/models/localizacao.dart';
import 'package:localizacoes/features/localizacoes/presentation/widgets/mapa_localizacoes.dart';
import 'package:localizacoes/features/localizacoes/services/cache_mapa.dart';

typedef _DadosMapa = ({
  MapCachingProvider cache,
  List<Localizacao> localizacoes,
});

class TelaMapa extends StatefulWidget {
  const TelaMapa({super.key});

  @override
  State<TelaMapa> createState() => _TelaMapaState();
}

class _TelaMapaState extends State<TelaMapa> {
  final _repositorio = const RepositorioLocalizacoes();
  late Future<_DadosMapa> _dados = _carregar();

  Future<_DadosMapa> _carregar() async {
    final cache = await CacheMapa.preparar();
    final localizacoes = await _repositorio.listarUltimas();
    return (cache: cache, localizacoes: localizacoes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _dados = _carregar();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _dados,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar o mapa: ${snapshot.error}'),
            );
          }
          final dados = snapshot.requireData;
          if (dados.localizacoes.isEmpty) {
            return const Center(child: Text('Nenhuma localização registrada.'));
          }
          return MapaLocalizacoes(
            localizacoes: dados.localizacoes,
            cache: dados.cache,
          );
        },
      ),
    );
  }
}
