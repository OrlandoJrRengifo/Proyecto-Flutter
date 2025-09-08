import '../entities/user.dart';
import '../repositories/i_auth_repository.dart';

class AuthenticationUseCase {
  final IAuthRepository _repository;
  AuthenticationUseCase(this._repository);

  Future<bool> login(String email, String password) async =>
      await _repository.login(User(email: email, name: email, password: password));

  Future<bool> signUp(String email, String name, String password) async =>
      await _repository.signUp(User(email: email, name: name, password: password));

  Future<bool> logOut() async => await _repository.logOut();
}
