import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/course_model.dart';
import 'i_course_local_datasource.dart';

class CourseLocalDataSourceSqflite implements ICourseLocalDataSource {
  Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'DataBase.db');
    
    return await openDatabase(
      path,
      version: 2, 
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }
  
  Future<void> _onCreate(Database db, int version) async {
    // Crear tabla categories (si no existe)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        courseId INTEGER NOT NULL,
        name TEXT NOT NULL,
        grouping_method TEXT NOT NULL,
        max_group_size INTEGER,
        created_at TEXT DEFAULT (datetime('now'))
      )
    ''');

    // Crear tabla courses
    await db.execute('''
      CREATE TABLE courses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        code TEXT NOT NULL,
        teacher_id INTEGER NOT NULL,
        max_students INTEGER NOT NULL,
        created_at TEXT DEFAULT (datetime('now'))
      )
    ''');
    
    print("✅ Tablas categories y courses creadas");
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Agregar tabla courses si no existe
      await db.execute('''
        CREATE TABLE IF NOT EXISTS courses (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          code TEXT NOT NULL,
          teacher_id INTEGER NOT NULL,
          max_students INTEGER NOT NULL,
          created_at TEXT DEFAULT (datetime('now'))
        )
      ''');
      print("✅ Tabla courses agregada en upgrade");
    }
  }
  
  @override
  Future<CourseModel> create(CourseModel course) async {
    final db = await database;
    
    print("📌 DataSource -> insertando curso ${course.toMap()}");
    
    final newId = await db.insert('courses', course.toMap());
    print("✅ Curso insertado con id=$newId");
    
    final inserted = await db.query(
      'courses',
      where: 'id = ?',
      whereArgs: [newId],
    );
    
    print("📌 Curso recuperado: $inserted");
    return CourseModel.fromMap(inserted.first);
  }
  
  @override
  Future<void> delete(int id) async {
    final db = await database;
    await db.delete('courses', where: 'id = ?', whereArgs: [id]);
    print("✅ Curso eliminado con id=$id");
  }
  
  @override
  Future<CourseModel?> getById(int id) async {
    final db = await database;
    final maps = await db.query(
      'courses',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    
    if (maps.isEmpty) return null;
    return CourseModel.fromMap(maps.first);
  }
  
  @override
  Future<List<CourseModel>> listByTeacher(int teacherId) async {
    final db = await database;
    final maps = await db.query(
      'courses',
      where: 'teacher_id = ?',
      whereArgs: [teacherId],
      orderBy: 'created_at DESC',
    );
    
    return maps.map((m) => CourseModel.fromMap(m)).toList();
  }
  
  @override
  Future<CourseModel> update(CourseModel course) async {
    final db = await database;
    final map = course.toMap();
    final id = course.id;
    
    if (id == null) {
      throw Exception('Se requiere el id del curso para actualizar');
    }
    
    await db.update('courses', map, where: 'id = ?', whereArgs: [id]);
    
    final maps = await db.query(
      'courses',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    
    return CourseModel.fromMap(maps.first);
  }

  @override
  Future<int> countByTeacher(int teacherId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM courses WHERE teacher_id = ?',
      [teacherId],
    );
    
    return result.first['count'] as int;
  }
}