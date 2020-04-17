import 'package:bytebankoficial/models/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

/*TESTE DE UNIDADE*/
void main (){
  test('Should return the value when create a transaction', (){
    final transaction = Transaction(null, 200, null);
    expect(transaction.value, 200);
  });
  test('Should show error when create a transaction with value less than zero', (){
    expect(() => Transaction(null, 0, null), throwsAssertionError);
  });
}