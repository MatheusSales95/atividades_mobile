import 'package:sqflite/sqflite.dart';

class BancoLocalizacoes {
  static const tabela = 'localizacoes';

  static Database? _banco;

  // Reutiliza a conexão já aberta. Se a abertura falhar, _banco continua nulo
  // e a próxima chamada tenta abrir de novo.
  static Future<Database> abrir() async {
    return _banco ??= await openDatabase(
      'localizacoes.db', // relativo à pasta de bancos do aplicativo
      version: 1,
      onCreate: (db, version) => db.execute('''
        CREATE TABLE $tabela (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          latitude REAL NOT NULL,
          longitude REAL NOT NULL,
          precisao REAL NOT NULL,
          instante TEXT NOT NULL
        )
      '''),
    );
  }
}
