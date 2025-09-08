import '../../domain/entities/user.dart';

abstract class IAuthenticationSource {
  Future<bool> login(User user);
  Future<bool> signUp(User user);
  Future<bool> logOut();
}
