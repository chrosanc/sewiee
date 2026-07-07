import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sewiee/data/model/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // =========================
  // CREATE USER
  // =========================

  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toJson());
  }

  // =========================
  // GET CURRENT USER
  // =========================

  Future<UserModel?> getCurrentUser() async {
    final uid = _auth.currentUser?.uid;

    if (uid == null) {
      return null;
    }

    final snapshot = await _firestore.collection('users').doc(uid).get();

    if (!snapshot.exists) {
      return null;
    }

    return UserModel.fromJson(snapshot.data()!);
  }

  // =========================
  // GET USER BY UID
  // =========================

  Future<UserModel?> getUserByUid(String uid) async {
    final snapshot = await _firestore.collection('users').doc(uid).get();

    if (!snapshot.exists) {
      return null;
    }

    return UserModel.fromJson(snapshot.data()!);
  }

  // =========================
  // UPDATE USER
  // =========================

  Future<void> updateUser({
    required String uid,

    String? fullName,
    String? username,

    String? bio,
    String? profileImage,
  }) async {
    final Map<String, dynamic> data = {};

    if (fullName != null) {
      data['full_name'] = fullName;
    }

    if (username != null) {
      data['username'] = username;
    }

    if (bio != null) {
      data['bio'] = bio;
    }

    if (profileImage != null) {
      data['profile_image'] = profileImage;
    }

    await _firestore.collection('users').doc(uid).update(data);
  }

  // =========================
  // UPDATE FCM TOKEN
  // =========================

  Future<void> updateFcmToken(String uid, String token) async {
    await _firestore.collection('users').doc(uid).update({
      'fcm_token': token,
    });
  }

  // =========================
  // CHECK USERNAME
  // =========================

  Future<bool> isUsernameTaken(String username) async {
    final result = await _firestore
        .collection('users')
        .where('username', isEqualTo: username.toLowerCase())
        .limit(1)
        .get();

    return result.docs.isNotEmpty;
  }
}
