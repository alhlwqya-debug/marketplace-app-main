import '../../data/models/user_model.dart';

abstract class AuthRepositoryInterface {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password, String name, String phone);
  Future<void> logout();
  Future<void> updateUser(UserModel user);
  Future<void> resetPassword(String email);
}
