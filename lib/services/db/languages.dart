import 'package:dokdok/services/db/db_manager.dart';
import 'package:dokdok/src/docker_template/data/languages.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LanguagesDbManager implements DbManager<Languages> {
  static const String tableName = 'ProgramLanguage';
  static const String columnId = 'language_id';
  static const String columnName = 'language_name';

  Database? _db;

  static final LanguagesDbManager _instance = LanguagesDbManager._internal();
  factory LanguagesDbManager() => _instance;
  LanguagesDbManager._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'dokdok.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS $tableName (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,
            $columnName TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Languages _fromMap(Map<String, dynamic> map) {
    return Languages(
      language_id: map[columnId] as int?,
      language_name: map[columnName] as String?,
    );
  }

  Map<String, dynamic> _toMap(Languages lang) {
    return {
      columnId: lang.languageId,
      columnName: lang.languageName,
    };
  }

  @override
  Future<void> insert(Languages item) async {
    final db = await database;
    await db.insert(
      tableName,
      _toMap(item),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(Languages item) async {
    final db = await database;
    await db.update(
      tableName,
      _toMap(item),
      where: '$columnId = ?',
      whereArgs: [item.languageId],
    );
  }

  @override
  Future<void> delete(int id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<Languages?> getById(int id) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return _fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<Languages>> getAll() async {
    final db = await database;
    final maps = await db.query(tableName);
    print('getAll: $maps, $db');
    return maps.map((map) => _fromMap(map)).toList();
  }
}