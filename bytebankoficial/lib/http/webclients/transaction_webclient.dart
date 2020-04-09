import 'dart:convert';
import 'package:bytebankoficial/http/webclient.dart';
import 'package:bytebankoficial/models/transaction.dart';
import 'package:http/http.dart';


class TransactionWebClient {

  /*Conversao Json para dart*/
  Future<List<Transaction>> findAll() async {
    final Response response =
        await client.get(baseUrl);
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson
        .map((dynamic json) => Transaction.fromJson(json))
        .toList();
  }

/*Conversao dart para Json*/
  Future<Transaction> save(Transaction transaction, String password) async {
    final String transactionJsonEncode = jsonEncode(transaction.toJson());

    await Future.delayed(Duration(seconds: 10));

    final Response response = await client.post(baseUrl,
        headers: {
          'Content-type': 'application/json',
          'password': password,
        },
        body: transactionJsonEncode);

    if (response.statusCode == 200){
      return Transaction.fromJson(jsonDecode(response.body));
    }
    throw HttpException(_getMessage(response.statusCode));
  }

  String _getMessage(int statusCode) {
    if(_statusCodeResponses.containsKey(statusCode)){
      return _statusCodeResponses[statusCode];
    }
    return 'Unknown error';
  }

  static final Map<int,String> _statusCodeResponses = {
    400 : 'There was an error submitting transaction',
    401 : 'Authentication failed',
    409 : 'Transaction already exists'
  };
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);
}
