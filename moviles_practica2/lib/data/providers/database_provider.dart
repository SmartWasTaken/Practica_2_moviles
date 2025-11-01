import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../core/models/score.dart';

class DatabaseProvider {
  // Hacemos esta clase un Singleton para asegurarnos de que solo hay una
  // instancia de la base de datos abierta en toda la app.
  DatabaseProvider._privateConstructor();
  static final DatabaseProvider instance = DatabaseProvider._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Inicializa la base de datos
  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'wordle.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB, // Esta función se ejecuta la primera vez que se crea la BD
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
      conflictAlgorithm: ConflictAlgorithm.replace, // Si hay conflicto, reemplaza
    );
  }

  // Método para obtener todas las puntuaciones, ordenadas de mayor a menor
  Future<List<Score>> getScores() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'rankings',
      orderBy: 'scoreValue DESC', // Ordenamos por puntuación
    );

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (i) {
      return Score.fromMap(maps[i]);
    });
  }
}