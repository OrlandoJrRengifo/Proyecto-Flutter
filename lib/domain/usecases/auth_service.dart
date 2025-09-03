import 'dart:io';
import 'package:path_provider/path_provider.dart';



class AuthService {
  static Future<File> _getUserFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/users.txt');
  }

  static Future<bool> register(String username, String password) async {
    final file = await _getUserFile();
    final users = await file.exists() ? await file.readAsLines() : [];
    if (users.any((line) => line.split(':')[0] == username)) {
      return false;
    }
    await file.writeAsString('$username:$password\n', mode: FileMode.append);
    return true;
  }

  static Future<bool> login(String username, String password) async {
    final file = await _getUserFile();
    if (!await file.exists()) return false;
    final users = await file.readAsLines();
    return users.any((line) {
      final parts = line.split(':');
      return parts[0] == username && parts[1] == password;
    });
  }
}