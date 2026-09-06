import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sewiee/data/model/user_model.dart';
import 'package:sewiee/domain/repositories/user_repository.dart';
import 'package:sewiee/presentation/account/account_viewmodel.dart';
import 'package:sewiee/presentation/widget/loading/loading_manager.dart';

class FakeUserRepository implements UserRepository {
  UserModel user;
  Map<String, String?>? update;

  FakeUserRepository(this.user);

  @override
  Future<void> createUser(UserModel user) async {}

  @override
  Future<UserModel?> getCurrentUser() async => user;

  @override
  Future<UserModel?> getUserByUid(String uid) async => user;

  @override
  Future<bool> isUsernameTaken(String username) async => false;

  @override
  Future<void> updateUser({
    required String uid,
    String? fullName,
    String? username,
    String? bio,
    String? profileImage,
  }) async {
    update = {
      'uid': uid,
      'fullName': fullName,
      'username': username,
      'bio': bio,
    };
    user = UserModel(
      uid: user.uid,
      fullName: fullName ?? user.fullName,
      username: username ?? user.username,
      email: user.email,
      phoneNumber: user.phoneNumber,
      bio: bio,
      profileImage: user.profileImage,
      storeName: user.storeName,
      storeUsername: user.storeUsername,
    );
  }
}

void main() {
  test('updateProfile menyimpan lalu menyegarkan profil pengguna', () async {
    final repository = FakeUserRepository(
      UserModel(
        uid: 'user-1',
        fullName: 'Nama Lama',
        username: 'lama',
        email: 'user@example.com',
        phoneNumber: '0812',
        storeName: '',
        storeUsername: '',
      ),
    );
    final viewModel = AccountViewmodel(
      auth: MockFirebaseAuth(),
      userRepository: repository,
      loadingManager: LoadingManager(),
    )..userModel = repository.user;

    final result = await viewModel.updateProfile(
      fullName: 'Nama Baru',
      username: 'baru',
      bio: 'Bio baru',
    );

    expect(result, isTrue);
    expect(repository.update, {
      'uid': 'user-1',
      'fullName': 'Nama Baru',
      'username': 'baru',
      'bio': 'Bio baru',
    });
    expect(viewModel.userModel?.fullName, 'Nama Baru');
  });
}
