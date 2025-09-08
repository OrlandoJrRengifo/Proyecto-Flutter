import '../../domain/entities/user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/i_auth_source.dart';

class AuthRepository implements IAuthRepository {
  final IAuthenticationSource authenticationSource;

  AuthRepository(this.authenticationSource);

  @override
  Future<bool> login(User user) async => await authenticationSource.login(user);

  @override
  Future<bool> signUp(User user) async => await authenticationSource.signUp(user);

  @override
  Future<bool> logOut() async => await authenticationSource.logOut();
}
