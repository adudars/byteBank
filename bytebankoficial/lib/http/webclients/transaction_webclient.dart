import 'dart:convert';
import 'package:bytebankoficial/http/webclient.dart';
import 'package:bytebankoficial/models/transaction.dart';
import 'package:http/http.dart';


class TransactionWebClient {

  /*Conversao Json para dart*/
  Future<List<Transaction>> findAll() async {
    final Response response =
        await client.get(baseUrl).timeout(Duration(seconds: 8));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson
        .map((dynamic json) => Transaction.fromJson(json))
        .toList();
  }

/*Conversao dart para Json*/
  Future<Transaction> save(Transaction transaction) async {
    final String transactionJsonEncode = jsonEncode(transaction.toJson());
    final Response response = await client.post(baseUrl,
        headers: {
          'Content-type': 'application/json',
          'password': '1000',
        },
        body: transactionJsonEncode);
    return Transaction.fromJson(jsonDecode(response.body));
  }
}
