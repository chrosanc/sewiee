import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sewiee/presentation/login/login_screen.dart';

/// True if logged in; otherwise opens LoginScreen and returns whether login succeeded.
Future<bool> requireLogin(BuildContext context) async {
  if (FirebaseAuth.instance.currentUser != null) return true;
  final ok = await Navigator.push<bool>(
    context,
    MaterialPageRoute(builder: (_) => const LoginScreen()),
  );
  return ok == true;
}
