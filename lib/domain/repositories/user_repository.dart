import 'package:sewiee/data/model/user_model.dart';
import 'package:sewiee/data/services/user_service.dart';

class UserRepository {

  final UserService _service =
  UserService();

  // =========================
  // CREATE USER
  // =========================

  Future<void> createUser(
      UserModel user,
      ) async {

    await _service.createUser(user);
  }

  // =========================
  // GET CURRENT USER
  // =========================

  Future<UserModel?> getCurrentUser() async {

    return await _service
        .getCurrentUser();
  }

  // =========================
  // GET USER BY UID
  // =========================

  Future<UserModel?> getUserByUid(
      String uid,
      ) async {

    return await _service
        .getUserByUid(uid);
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

    await _service.updateUser(
      uid: uid,
      fullName: fullName,
      username: username,
      bio: bio,
      profileImage: profileImage,
    );
  }

  // =========================
  // CHECK USERNAME
  // =========================

  Future<bool> isUsernameTaken(
      String username,
      ) async {

    return await _service
        .isUsernameTaken(username);
  }
}