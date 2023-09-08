import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, 'auth_database.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE auth_tokens (
        id INTEGER PRIMARY KEY,
        token TEXT
      )
    ''');
  }

  Future<void> saveToken(String token) async {
    final db = await database;
    await db.insert('auth_tokens', {'token': token});
  }

  Future<String?> loadToken() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('auth_tokens');
    if (maps.isNotEmpty) {
      return maps.first['token'] as String;
    }
    return null;
  }

  Future<void> clearTokens() async {
    final db = await database;
    await db.delete('auth_tokens');
  }
}
