import 'package:localizacoes/features/localizacoes/data/database/banco_localizacoes.dart';
import 'package:localizacoes/features/localizacoes/models/localizacao.dart';

class RepositorioLocalizacoes {
  const RepositorioLocalizacoes();

  Future<void> inserir(Localizacao localizacao) async {
    final banco = await BancoLocalizacoes.abrir();
    await banco.insert(BancoLocalizacoes.tabela, localizacao.toMap());
  }

  Future<List<Localizacao>> listarUltimas() async {
    final banco = await BancoLocalizacoes.abrir();
    final linhas = await banco.query(
      BancoLocalizacoes.tabela,
      orderBy: 'instante DESC',
      limit: 100,
    );
    return linhas.map(Localizacao.fromMap).toList();
  }

  Future<void> excluirTodas() async {
    final banco = await BancoLocalizacoes.abrir();
    await banco.delete(BancoLocalizacoes.tabela);
  }
}
