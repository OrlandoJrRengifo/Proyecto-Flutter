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
        // Tabla de usuarios
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
          )
        ''');

        // Tabla de categorías
        await db.execute('''
          CREATE TABLE categories(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL
          )
        ''');

        // Tabla de cursos
        await db.execute('''
          CREATE TABLE courses(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            code TEXT NOT NULL UNIQUE,
            teacherId INTEGER,
            capacity INTEGER NOT NULL,
            currCap INTEGER NOT NULL DEFAULT 0
          )
        ''');

        // Tabla intermedia usuario ↔ curso
        await db.execute('''
          CREATE TABLE user_courses(
            user_id INTEGER NOT NULL,
            course_id INTEGER NOT NULL,
            PRIMARY KEY (user_id, course_id),
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
            FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
          )
        ''');

        // Datos iniciales de usuarios
        final users = [
          {"id": 1, "name": "Amanda Álvarez", "email": "a@a.com", "password": "123456"},
          {"id": 2, "name": "Brayan Aguirre", "email": "b@a.com", "password": "123456"},
          {"id": 3, "name": "Carlos Acevedo", "email": "c@a.com", "password": "123456"}
        ];
        for (var user in users) {
          await db.insert("users", user, conflictAlgorithm: ConflictAlgorithm.ignore);
        }

        // Crear curso inicial
        final course = {
          "id": 1,
          "title": "Curso1",
          "code": "ABC123",
          "teacherId": 1, // ejemplo
          "capacity": 30,
          "currCap": 0
        };
        await db.insert("courses", course, conflictAlgorithm: ConflictAlgorithm.ignore);

        // Asignar usuario id=2 al curso y aumentar currCap
        await db.insert("user_courses", {"user_id": 2, "course_id": 1},
            conflictAlgorithm: ConflictAlgorithm.ignore);

        await db.rawUpdate('''
          UPDATE courses
          SET currCap = currCap + 1
          WHERE id = 1
        ''');
      },
    );

    return _db!;
  }
}
