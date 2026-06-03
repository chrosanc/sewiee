import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sewiee/app/utils/toast.dart';
import 'package:sewiee/data/model/user_model.dart';
import 'package:sewiee/domain/repositories/user_repository.dart';
import 'package:sewiee/main.dart';
import 'package:sewiee/presentation/login/login_screen.dart';
import 'package:sewiee/presentation/widget/loading/loading_manager.dart';

class AccountViewmodel extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  UserModel? userModel;
  final UserRepository userRepository = UserRepository();

  /// =========================
  /// LOADING VARIABLE
  /// =========================
  final LoadingManager _loadingManager = serviceLocator<LoadingManager>();
  void _showLoadingDialog() => _loadingManager.showLoading();
  void _hideLoadingDialog() => _loadingManager.hideLoading();
  void showLoadingDialog() => _loadingManager.showLoading();



  Future<void> getCurrentUser(BuildContext context) async {
    _showLoadingDialog();
    try {
      userModel = await userRepository.getCurrentUser();
      notifyListeners();
    } catch (e) {
      Toast().showToast(context, e.toString());
    } finally {
      _hideLoadingDialog();
    }
  }

  Future<void> logout(BuildContext context) async {
    _showLoadingDialog();
    try {
      await auth.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      Toast().showToast(context,'Login Gagal : $e');
    } finally{
      _hideLoadingDialog();
    }
  }
}
