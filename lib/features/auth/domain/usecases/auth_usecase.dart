import '../entities/user.dart';
import '../repositories/i_auth_repository.dart';

class AuthenticationUseCase {
  final IAuthRepository _repository;
  AuthenticationUseCase(this._repository);

  Future<User?> login(String email, String password) async {
    return await _repository.login(email, password);
  }

  Future<bool> signUp(String email, String name, String password) async =>
      await _repository.signUp(User(email: email, name: name, password: password));

  Future<bool> logOut() async => await _repository.logOut();
}
