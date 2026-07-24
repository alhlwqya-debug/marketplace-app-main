import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<UserModel> call(String email, String password, String name, String phone) {
    return repository.register(email, password, name, phone);
  }
}
