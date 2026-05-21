import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sewiee/app/utils/toast.dart';
import 'package:sewiee/data/model/user_model.dart';
import 'package:sewiee/domain/repositories/user_repository.dart';
import 'package:sewiee/presentation/login/login_screen.dart';

class AccountViewmodel extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  UserModel? userModel;
  final UserRepository userRepository = UserRepository();
  bool isLoading = false;


  Future<void> getCurrentUser(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      userModel = await userRepository.getCurrentUser();
    } catch (e) {
      Toast().showToast(context, e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await auth.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      Toast().showToast(context,'Login Gagal : $e');
    }
  }
}
