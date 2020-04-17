import 'package:bytebankoficial/database/DAO/contact_dao.dart';
import 'package:bytebankoficial/widgtes/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bytebankoficial/models/contact.dart';

class ContactForm extends StatefulWidget {

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _controladorNewContact = TextEditingController();
  final TextEditingController _controladorAccountNumber =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dependencies = AppDependencies.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('New Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controladorNewContact,
              decoration: InputDecoration(
                labelText: 'Full name',
              ),
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _controladorAccountNumber,
                decoration: InputDecoration(
                  labelText: 'Account number',
                ),
                style: TextStyle(
                  fontSize: 24.0,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: RaisedButton(
                  child: Text('Create'),
                  onPressed: () {
                    final String newContact = _controladorNewContact.text;
                    final int accountNumber =
                        int.tryParse(_controladorAccountNumber.text);
                    final Contact contact =
                        Contact(0, newContact, accountNumber);

                    _save(dependencies.contactDao,contact, context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save(ContactDao contactDao,Contact contact, BuildContext context) async{
    await contactDao.save(contact);
    Navigator.pop(context);
  }
}
