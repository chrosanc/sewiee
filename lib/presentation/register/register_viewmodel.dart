import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sewiee/app/utils/toast.dart';
import 'package:sewiee/data/model/user_model.dart';
import 'package:sewiee/domain/repositories/otp_repository.dart';
import 'package:sewiee/presentation/main/main_screen.dart';
import 'package:sewiee/presentation/register/otp_screen.dart';

class RegisterViewModel extends ChangeNotifier {
  // =========================
  // OTP
  // =========================

  final OtpRepository otpRepository = OtpRepository();

  int? _resendToken;

  int? get resendToken => _resendToken;

  // =========================
  // RESEND OTP TIMER
  // =========================

  Timer? _resendTimer;
  int _resendCooldown = 60;
  bool _canResendOtp = false;

  int get resendCooldown => _resendCooldown;

  bool get canResendOtp => _canResendOtp;

  // =========================
  // UI STATE
  // =========================

  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;
  bool _isLoading = false;

  bool _isUsernameFilled = false;
  bool _isFullNameFilled = false;
  bool _isEmailFilled = false;
  bool _isPhoneFilled = false;
  bool _isPasswordFilled = false;
  bool _isConfirmPasswordFilled = false;

  bool get isPasswordObscured => _isPasswordObscured;

  bool get isConfirmPasswordObscured => _isConfirmPasswordObscured;

  bool get isLoading => _isLoading;

  // =========================
  // FIREBASE
  // =========================

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // =========================
  // REGISTER DATA
  // =========================
  String? _verificationId;
  String? _userFullName;
  String? _userName;
  String? _userEmail;
  String? _userPhoneNumber;
  String? _password;
  String? _passwordConfirmation;
  UserModel? userData;

  // =========================
  // GETTERS
  // =========================

  String? get verificationId => _verificationId;

  String? get userFullName => _userFullName;

  String? get userName => _userName;

  String? get userEmail => _userEmail;

  String? get userPhoneNumber => _userPhoneNumber;

  String? get password => _password;

  String? get passwordConfirmation => _passwordConfirmation;

  UserModel? get user => userData;

  // =========================
  // TOGGLE PASSWORD VISIBILITY
  // =========================

  void togglePasswordVisibility() {
    _isPasswordObscured = !_isPasswordObscured;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
    notifyListeners();
  }

  // =========================
  // INPUT STATE , SETTER
  // =========================

  void updateFullNameFilled(
    bool value,
    TextEditingController fullNameController,
  ) {
    _isFullNameFilled = value;
    _userFullName = fullNameController.text.trim();
    notifyListeners();
  }

  void updateUsernameFilled(
    bool value,
    TextEditingController userNameController,
  ) {
    _isUsernameFilled = value;
    _userName = userNameController.text.trim();
    notifyListeners();
  }

  void updateEmailFilled(bool value, TextEditingController emailController) {
    _isEmailFilled = value;
    _userEmail = emailController.text.trim();
    notifyListeners();
  }

  void updatePhoneFilled(
    bool value,
    TextEditingController phoneNumberController,
  ) {
    _isPhoneFilled = value;
    _userPhoneNumber = phoneNumberController.text.trim();
    notifyListeners();
  }

  void updatePasswordFilled(
    bool value,
    TextEditingController passwordController,
  ) {
    _isPasswordFilled = value;
    _password = passwordController.text.trim();
    notifyListeners();
  }

  void updateConfirmPasswordFilled(
    bool value,
    TextEditingController passwordConfirmationController,
  ) {
    _isConfirmPasswordFilled = value;
    _passwordConfirmation = passwordConfirmationController.text.trim();
    notifyListeners();
  }

  // =========================
  // FORM VALIDATION
  // =========================

  bool isFormValid() {
    return _isUsernameFilled &&
        _isFullNameFilled &&
        _isEmailFilled &&
        _isPhoneFilled &&
        _isPasswordFilled &&
        _isConfirmPasswordFilled &&
        _password == _passwordConfirmation;
  }

  // =========================
  // REGISTER USER
  // =========================

  Future<void> registerPhoneNumber(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await otpRepository.sendOtp('+62$_userPhoneNumber');

      if (result['success']) {
        startResendCooldown();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => OtpScreen()),
        );
      } else {
        Toast().showToast(context, result['message']);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // START COOLDOWN
  // =========================

  void startResendCooldown() {
    _canResendOtp = false;

    _resendCooldown = 60;

    notifyListeners();

    _resendTimer?.cancel();

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown > 0) {
        _resendCooldown--;
        notifyListeners();
      } else {
        _canResendOtp = true;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  // =========================
  // VERIFY OTP
  // =========================

  Future<bool> verifyOtpAndRegisterUser(
    BuildContext context,
    String otpCode,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await otpRepository.verifyOtp('+62${_userPhoneNumber!.trim()}', otpCode.trim(),);
      if (!result['success']) {
        Toast().showToast(context, result['message']);
        return false;
      }
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: _userEmail!,
        password: _password!,
      );

      final user = userCredential.user;

      if (user == null) {
        return false;
      }
      final profile = UserModel(
        uid: user.uid,
        fullName: _userFullName!,
        email: _userEmail!,
        phoneNumber: '+62${_userPhoneNumber!}',
        username: _userName!,
        storeName: '${_userName!} Store',
        storeUsername: '${_userName!.toLowerCase()}_store',
      );

      await _firestore.collection('users').doc(user.uid).set(profile.toJson());

      Toast().showToast(context, "Registration Successful");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
        (route) => false,
      );

      return true;
    } catch (e) {
      debugPrint("OTP Verification Error: $e");
      Toast().showToast(context, "OTP Verification Failed");

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // RESEND OTP
  // =========================

  Future<void> resendOtp(BuildContext context) async {
    try {
      final result = await otpRepository.sendOtp('+62$_userPhoneNumber');
      if(result['success']) {
        startResendCooldown();
        Toast().showToast(
          context,
          "OTP sudah dikirim kembali",
        );
      } else {
        Toast().showToast(context, result['message']);
      }
    } catch (e) {
      Toast().showToast(context, e.toString());
    }
  }

  @override
  void dispose() {
    _resendTimer?.cancel();

    super.dispose();
  }
}
