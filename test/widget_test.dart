import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'package:sewiee/presentation/splash/splash_screen.dart';

void main() {
  testWidgets('Splash screen renders app name', (WidgetTester tester) async {
    final mockAuth = MockFirebaseAuth();

    await tester.pumpWidget(
      MaterialApp(
        home: SplashScreen(auth: mockAuth),
      ),
    );

    expect(find.text('Sewiee'), findsOneWidget);
  });
}
