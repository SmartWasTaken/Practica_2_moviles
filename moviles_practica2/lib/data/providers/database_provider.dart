import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../core/models/score.dart';

class DatabaseProvider {
  DatabaseProvider._privateConstructor();
  static final DatabaseProvider instance = DatabaseProvider._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'wordle.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Crea la tabla de rankings
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE rankings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        scoreValue INTEGER NOT NULL,
        difficulty TEXT NOT NULL,
        timeInSeconds INTEGER NOT NULL,
        attempts INTEGER NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  // Método para insertar una nueva puntuación
  Future<void> insertScore(Score score) async {
    final db = await instance.database;
    await db.insert(
      'rankings',
      score.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Score>> getScores() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'rankings',
      orderBy: 'scoreValue DESC',
    );

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (i) {
      return Score.fromMap(maps[i]);
    });
  }
}