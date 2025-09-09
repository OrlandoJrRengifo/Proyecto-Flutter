import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/category_model.dart';
import 'i_category_local_datasource.dart';

class CategoryLocalDataSourceSqflite implements ICategoryLocalDataSource {
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
      version: 1,
      onCreate: _onCreate,
    );
  }
  
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        courseId INTEGER NOT NULL,
        name TEXT NOT NULL,
        grouping_method TEXT NOT NULL,
        max_group_size INTEGER,
        created_at TEXT DEFAULT (datetime('now'))
      )
    ''');
  
  }
  
  @override
  Future<CategoryModel> create(CategoryModel category) async {
    final db = await database;
    final newId = await db.insert('categories', category.toMap());
    final inserted = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [newId],
    );
    return CategoryModel.fromMap(inserted.first);
  }
  
  @override
  Future<void> delete(int id) async {
    final db = await database;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }
  
  @override
  Future<CategoryModel?> getById(int id) async {
    final db = await database;
    final maps = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    
    if (maps.isEmpty) return null;
    return CategoryModel.fromMap(maps.first);
  }
  
  @override
  Future<List<CategoryModel>> listByCourse(int courseId) async {
    final db = await database;
    final maps = await db.query(
      'categories',
      where: 'courseId = ?',
      whereArgs: [courseId],
    );
    
    return maps.map((m) => CategoryModel.fromMap(m)).toList();
  }
  
  @override
  Future<CategoryModel> update(CategoryModel category) async {
    final db = await database;
    final map = category.toMap();
    final id = category.id;
    
    if (id == null) {
      throw Exception('Se requiere el id de la categoría para actualizar');
    }
    
    await db.update('categories', map, where: 'id = ?', whereArgs: [id]);
    
    final maps = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    
    return CategoryModel.fromMap(maps.first);
  }
}