import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sewiee/app/utils/toast.dart';
import 'package:sewiee/presentation/main/main_screen.dart';

class LoginViewModel extends ChangeNotifier {
  bool isEmailFilled = false;
  bool isPasswordFilled = false;

  bool loading = false;
  bool obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void togglePasswordVisibility() {
    obscureText = !obscureText;
    notifyListeners();
  }

  bool isFilled() {
    if (isEmailFilled && isPasswordFilled) return true;
    return false;
  }

  void updateEmailFilled(bool value) {
    isEmailFilled = value;
    notifyListeners();
  }

  void updatePasswordFilled(bool value) {
    isPasswordFilled = value;
    notifyListeners();
  }

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      loading = true;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Toast().showToast(context, "Login Berhasil");

      // Opened by requireLogin: return to the guarded action.
      if (Navigator.canPop(context)) {
        Navigator.pop(context, true);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
    } catch (e) {
      Toast().showToast(context, e.toString());
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
