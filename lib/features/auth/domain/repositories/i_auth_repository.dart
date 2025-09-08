import '../entities/user.dart';

abstract class IAuthRepository {
  Future<bool> login(User user); //duda del usuario

  Future<bool> signUp(User user);

  Future<bool> logOut();
}