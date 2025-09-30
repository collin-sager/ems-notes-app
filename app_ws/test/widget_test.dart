import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_ws/main.dart';

void main() {
  testWidgets('displays login form on startup', (WidgetTester tester) async {
    await tester.pumpWidget(const EMSNotesApp());

    expect(find.text('EMS Notes Login'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Username'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('shows an error message for invalid credentials', (WidgetTester tester) async {
    await tester.pumpWidget(const EMSNotesApp());

    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'wrong');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'credentials');
    await tester.tap(find.text('Login'));

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Invalid username or password'), findsOneWidget);
  });

  testWidgets('navigates to the home page after a successful login', (WidgetTester tester) async {
    await tester.pumpWidget(const EMSNotesApp());

    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'admin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password');
    await tester.tap(find.text('Login'));

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('EMS Notes Login'), findsNothing);
    expect(find.text('Patient Info'), findsOneWidget);
    expect(find.text('Vitals'), findsOneWidget);
    expect(find.text('Report'), findsOneWidget);
  });
}
