import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import '../../domain/usecases/auth_usecase.dart';
import '../../domain/entities/user.dart';

class AuthenticationController extends GetxController {
  final AuthenticationUseCase _authUseCase;

  AuthenticationController(this._authUseCase);

  final Rxn<User> currentUser = Rxn<User>();
  bool get isLoggedIn => currentUser.value != null;

  @override
  Future<void> onInit() async {
    super.onInit();
    logInfo('AuthenticationController initialized');
  }

  Future<bool> login(String email, String password) async {
    final user = await _authUseCase.login(email, password);
    if (user != null) {
      currentUser.value = user;
      return true;
    }
    return false;
  }

  Future<bool> signUp(String email, String name, String password) async {
    logInfo('AuthenticationController: Sign Up $email');
    final rta = await _authUseCase.signUp(email, name, password);
    if (rta) {
      currentUser.value = User(email: email, name: name, password: password);
    }
    return rta;
  }

  Future<void> logOut() async {
    await _authUseCase.logOut();
    currentUser.value = null;
  }
}
