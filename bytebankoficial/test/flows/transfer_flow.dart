import 'package:bytebankoficial/components/response_dialog.dart';
import 'package:bytebankoficial/components/transaction_auth_dialog.dart';
import 'package:bytebankoficial/main.dart';
import 'package:bytebankoficial/models/contact.dart';
import 'package:bytebankoficial/models/transaction.dart';
import 'package:bytebankoficial/screens/contacts_list.dart';
import 'package:bytebankoficial/screens/dashboard.dart';
import 'package:bytebankoficial/screens/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../matchers/matchers.dart';
import '../mocks/mocks.dart';
import 'actions.dart';

/*Fluxo de transferencia*/
void main() {
  testWidgets('Should transfer to a contact', (tester) async {
    final mockContactDao = MockContactDao();
    final mockTransactionWebClient = MockTransactionWebClient();
    await tester.pumpWidget(BytebankApp(
      contactDao: mockContactDao,
      transactionWebClient: mockTransactionWebClient,
    ));

    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);

    final duda = Contact(0, 'Duda', 3245);
    when(mockContactDao.findAll()).thenAnswer((invocation) async => [duda]);

    await clickOnTheTransferFeatureItem(tester);
    await tester.pumpAndSettle();

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);

    /*Função do mockito - verifica se funcao e chamada*/
    verify(mockContactDao.findAll()).called(1);

    final contactItem = find.byWidgetPredicate((widget) {
      if (widget is ContactItem) {
        return widget.contact.name == 'Duda' &&
            widget.contact.accountNumber == 3245;
      }
      return false;
    });
    expect(contactItem, findsOneWidget);

    await tester.tap(contactItem);
    await tester.pumpAndSettle();

    final transactionForm = find.byType(TransactionForm);
    expect(transactionForm, findsOneWidget);

    final contactName = find.text('Duda');
    expect(contactName, findsOneWidget);

    final contactAccountNumber = find.text('3245');
    expect(contactAccountNumber, findsOneWidget);

    final textFieldValue = find.byWidgetPredicate((widget) {
      return textFieldByLabelTextMatcher(widget, 'Value');
    });
    expect(textFieldValue, findsOneWidget);
    await tester.enterText(textFieldValue, '7777');

    final transferButton = find.widgetWithText(RaisedButton, 'Transfer');
    expect(transferButton, findsOneWidget);
    await tester.tap(transferButton);
    await tester.pumpAndSettle();

    final transactionAuthDialog = find.byType(TransactionAuthDialog);
    expect(transactionAuthDialog, findsOneWidget);

    final textFieldPassword =
        find.byKey(transactionAuthDialogTextFieldPasswordKey);
    expect(textFieldPassword, findsOneWidget);
    await tester.enterText(textFieldPassword, '1000');

    final cancelButton = find.widgetWithText(FlatButton, 'Cancel');
    expect(cancelButton, findsOneWidget);

    final confirmButton = find.widgetWithText(FlatButton, 'Confirm');
    expect(confirmButton, findsOneWidget);

    when(mockTransactionWebClient.save(Transaction(null, 7777, duda), '1000'))
        .thenAnswer((_) async => Transaction(null, 7777, duda));

    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    final successDialog = find.byType(SuccessDialog);
    expect(successDialog,findsOneWidget);

    final okButton = find.widgetWithText(FlatButton, 'Ok');
    expect(okButton, findsOneWidget);

    await tester.tap(okButton);
    await tester.pumpAndSettle();

    final contactsListBack = find.byType(ContactsList);
    expect(contactsListBack, findsOneWidget);
  });
}
