import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Database? _db;

  static Future<Database> get instance async {
    if (_db != null) return _db!;

    final path = join(await getDatabasesPath(), 'app.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Aquí creas todas las tablas necesarias
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE categories(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE courses(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT
          )
        ''');

        // Datos iniciales de usuarios
        final users = [
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
        ];
        for (var user in users) {
          await db.insert("users", user,
              conflictAlgorithm: ConflictAlgorithm.ignore);
        }
      },
    );

    return _db!;
  }
}
