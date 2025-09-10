import '../../domain/entities/user.dart';
import 'i_auth_source.dart';

class AuthenticationFakeSource implements IAuthenticationSource {
  final Map<String, dynamic> _jsonDb = {
    "users": [
      {
        "id": 1,
        "name": "Amanda Álvarez",
        "email": "a@a.com",
        "password": "123456"
      },
      {
        "id": 2,
        "name": "Brayan Aguirre",
        "email": "b@a.com",
        "password": "123456"
      },
      {
        "id": 3,
        "name": "Carlos Acevedo",
        "email": "c@a.com",
        "password": "123456"
      }
    ]
  };

  List<Map<String, dynamic>> get _users =>
      List<Map<String, dynamic>>.from(_jsonDb["users"]);

  @override
  Future<bool> login(User user) async {
    final found = _users.any((u) =>
        u["email"] == user.email && u["password"] == user.password);
    return Future.value(found);
  }

  @override
  Future<bool> signUp(User user) async {
    final exists = _users.any((u) => u["email"] == user.email);
    if (exists) return Future.value(false);

    final newUser = {
      "id": _users.length + 1,
      "name": user.name,
      "email": user.email,
      "password": user.password,
    };
    _users.add(newUser);
    return Future.value(true);
  }

  @override
  Future<bool> logOut() async => Future.value(true);

}
