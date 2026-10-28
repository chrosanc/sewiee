import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sewiee/app/theme.dart';
import 'package:sewiee/presentation/login/login_screen.dart';
import 'package:sewiee/presentation/main/main_screen.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, FirebaseAuth? auth}) : _auth = auth;

  final FirebaseAuth? _auth;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  late final FirebaseAuth _auth;
  Timer? _redirectTimer;

  @override
  void initState() {
    super.initState();
    _auth = widget._auth ?? FirebaseAuth.instance;
    _redirectTimer = Timer(const Duration(seconds: 3), () {
      if(!mounted) return;

      if(_auth.currentUser != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    });
  }

  @override
  void dispose() {
    _redirectTimer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Sewiee", style: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.bold, color: themeData.primaryColor),),
      ),
    );
  }
}
