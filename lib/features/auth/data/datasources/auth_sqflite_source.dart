import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/user.dart';
import 'i_auth_source.dart';

class AuthenticationLocalSource implements IAuthenticationSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final path = join(await getDatabasesPath(), 'auth.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
          )
        ''');
      },
    );
    return _database!;
  }

  @override
  Future<bool> login(User user) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [user.email, user.password],
    );
    return maps.isNotEmpty;
  }

  @override
  Future<bool> signUp(User user) async {
    final db = await database;
    try {
      await db.insert('users', user.toJson());
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> logOut() async => true;
}
