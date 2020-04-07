import 'package:bytebankoficial/database/DAO/contact_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  /*Criando o caminho do BD*/
  final String path = join(await getDatabasesPath(), 'bytebank.db');

  /*Abrindo o BD*/
  return openDatabase(
    path,
    onCreate: (db, version) {
      /*Criando a tabela*/
      db.execute(ContactDao.tableSql);
    },
    version: 1,
    //onDowngrade: onDatabaseDowngradeDelete,
  );
}



