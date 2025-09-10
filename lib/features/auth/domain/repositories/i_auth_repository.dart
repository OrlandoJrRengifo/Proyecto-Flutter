import '../entities/user.dart';

abstract class IAuthRepository {
  Future<User?> login(String email, String password);

  Future<bool> signUp(User user);

  Future<bool> logOut();
}