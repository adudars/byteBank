import 'package:bytebankoficial/models/contact.dart';
import 'package:sqflite/sqflite.dart';
import '../app_database.dart';

class ContactDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_name TEXT, '
      '$_accountNumber INTEGER)';
  static const String _tableName = 'contacts';
  static const _id = 'id';
  static const _name = 'name';
  static const _accountNumber = 'account_number';


  Future<int> save(Contact contact) async {
    final Database db = await getDatabase();

    Map<String, dynamic> contactMap = _toMap(contact);

    /*Inserindo na tabela*/
    return db.insert(_tableName,contactMap);
  }

  Future<List<Contact>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);

    List<Contact> contacts = _toList(result);

    return contacts;
  }

  Map<String, dynamic> _toMap(Contact contact) {
    /*Criando mapa para mandar informaçeõs*/
    final Map<String, dynamic> contactMap = Map();

    contactMap[_name] = contact.name;
    contactMap[_accountNumber] = contact.accountNumber;

    return contactMap;
  }

  List<Contact> _toList(List<Map<String, dynamic>> result) {
    final List<Contact> contacts = List();

    for (Map<String, dynamic> linha_tabela in result) {
      final Contact contact = Contact(
        linha_tabela[_id],
        linha_tabela[_name],
        linha_tabela[_accountNumber],
      );
      contacts.add(contact);
    }
    return contacts;
  }
}
