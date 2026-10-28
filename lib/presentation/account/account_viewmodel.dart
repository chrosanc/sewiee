import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sewiee/app/utils/toast.dart';
import 'package:sewiee/data/model/user_model.dart';
import 'package:sewiee/domain/repositories/user_repository.dart';
import 'package:sewiee/main.dart';
import 'package:provider/provider.dart';
import 'package:sewiee/presentation/main/main_screen.dart';
import 'package:sewiee/presentation/main/main_viewmodel.dart';
import 'package:sewiee/presentation/widget/loading/loading_manager.dart';

class AccountViewmodel extends ChangeNotifier {
  final FirebaseAuth auth;
  UserModel? userModel;
  final UserRepository userRepository;

  /// =========================
  /// LOADING VARIABLE
  /// =========================
  final LoadingManager _loadingManager;

  AccountViewmodel({
    FirebaseAuth? auth,
    UserRepository? userRepository,
    LoadingManager? loadingManager,
  }) : auth = auth ?? FirebaseAuth.instance,
       userRepository = userRepository ?? UserRepository(),
       _loadingManager = loadingManager ?? serviceLocator<LoadingManager>();
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

  Future<bool> updateProfile({
    required String fullName,
    required String username,
    required String bio,
  }) async {
    final user = userModel;
    if (user == null || fullName.trim().isEmpty || username.trim().isEmpty) {
      return false;
    }

    _showLoadingDialog();
    try {
      await userRepository.updateUser(
        uid: user.uid,
        fullName: fullName.trim(),
        username: username.trim().toLowerCase(),
        bio: bio.trim(),
      );
      userModel = await userRepository.getCurrentUser();
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    } finally {
      _hideLoadingDialog();
    }
  }

  Future<void> logout(BuildContext context) async {
    _showLoadingDialog();
    try {
      await auth.signOut();
      context.read<MainViewmodel>().navigateToPages(0);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (route) => false,
      );
    } catch (e) {
      Toast().showToast(context, 'Login Gagal : $e');
    } finally {
      _hideLoadingDialog();
    }
  }
}
