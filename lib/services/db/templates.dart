import 'package:dokdok/services/db/db_manager.dart';
import 'package:dokdok/src/docker_template/data/templates.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TemplatesDbManager implements DbManager<Templates> {
  static const String tableName = 'Template';
  static const String columnId = 'template_id';
  static const String columnCode = 'code';
  static const String columnProgramId = 'program_id';

  Database? _db;

  static final TemplatesDbManager _instance = TemplatesDbManager._internal();
  factory TemplatesDbManager() => _instance;
  TemplatesDbManager._internal();

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
            $columnCode TEXT,
            $columnProgramId INTEGER CONSTRAINT fk_languange_id REFERENCES ProgramLanguage (language_id) ON DELETE CASCADE
                                                                                            ON UPDATE CASCADE
          )
        ''');
      },
    );
  }

  Templates _fromMap(Map<String, dynamic> map) {
    return Templates(
      template_id: map[columnId] as int?,
      code: map[columnCode] as String?,
      program_id: map[columnProgramId] as int?,
    );
  }

  Map<String, dynamic> _toMap(Templates template) {
    return {
      columnId: template.templateId,
      columnCode: template.code,
      columnProgramId: template.programId,
    };
  }

  @override
  Future<void> insert(Templates item) async {
    final db = await database;
    await db.insert(
      tableName,
      _toMap(item),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> update(Templates item) async {
    final db = await database;
    await db.update(
      tableName,
      _toMap(item),
      where: '$columnId = ?',
      whereArgs: [item.templateId],
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
  Future<Templates?> getById(int id) async {
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
  Future<List<Templates>> getAll() async {
    final db = await database;
    final maps = await db.query(tableName);
    print('getAll: $maps, $db');
    return maps.map((map) => _fromMap(map)).toList();
  }

  Future<Templates?> getByProgramId(int programId) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: '$columnProgramId = ?',
      whereArgs: [programId],
    );
    if (maps.isNotEmpty) {
      return _fromMap(maps.first);
    }
    return null;
  }

}