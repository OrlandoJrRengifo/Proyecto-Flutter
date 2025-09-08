import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import '../../domain/usecases/auth_usecase.dart';

class AuthenticationController extends GetxController {
  final AuthenticationUseCase authentication;
  final logged = false.obs;

  AuthenticationController(this.authentication);

  @override
  Future<void> onInit() async {
    super.onInit();
    logInfo('AuthenticationController initialized');
  }

  bool get isLogged => logged.value;

  Future<bool> login(String email, String password) async {
    logInfo('AuthenticationController: Login $email');
    var rta = await authentication.login(email, password);
    logged.value = rta;
    return rta;
  }

  Future<bool> signUp(String email, String name, String password) async {
    logInfo('AuthenticationController: Sign Up $email');
    var rta = await authentication.signUp(email, name, password);
    logged.value = rta;
    return rta;
  }

  Future<void> logOut() async {
    logInfo('AuthenticationController: Log Out');
    await authentication.logOut();
    logged.value = false;
  }

}

