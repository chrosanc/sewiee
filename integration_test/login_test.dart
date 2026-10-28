import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sewiee/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login test', (WidgetTester tester) async {
    app.main();
    
    // Nunggu lebih lama biar SplashScreen/Firebase siap
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Cek apakah halaman LoginScreen sudah muncul
    // Kita cari teks khas di halaman login
    final loginTitle = find.text('Masuk ke akun Anda');
    
    // Kalau belum muncul, mungkin masih loading, coba tunggu lagi
    if (loginTitle.evaluate().isEmpty) {
      await tester.pumpAndSettle(const Duration(seconds: 5));
    }

    expect(loginTitle, findsOneWidget);

    // Cari TextFormField-nya
    final textFields = find.byType(TextFormField);
    expect(textFields, findsNWidgets(2)); 

    // Isi email & password
    await tester.enterText(textFields.at(0), 'sandhy@test.com');
    await tester.enterText(textFields.at(1), 'password123');

    // Klik tombol masuk
    await tester.tap(find.text('Masuk'));
    
    // Tunggu proses login (loading) selesai
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });
}
