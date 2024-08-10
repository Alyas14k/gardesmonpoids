import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BD {
  BD._privateConstructor();
  static final BD instance = BD._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final fullPath = join(dbPath, path);

    return await openDatabase(
      fullPath,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    try {
      // Création de la table users
      await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nom TEXT,
          prenom TEXT,
          username TEXT UNIQUE,
          email TEXT UNIQUE,
          password TEXT
        )
      ''');
      print('Table users créée');

      // Création de la table poids
      await db.execute('''
        CREATE TABLE poids (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          valeur_poids REAL,
          date_prise TEXT
        )
      ''');
      print('Table poids créée');
    } catch (e) {
      print('Erreur lors de la création des tables: $e');
    }
  }

  // Insertion de poids
  Future<void> insertPoids(Map<String, dynamic> poids) async {
    try {
      final db = await instance.database;
      await db.insert('poids', poids);
    } catch (e) {
      print('Erreur lors de l\'insertion de poids: $e');
    }
  }

  // Obtention de l'historique des poids
  Future<List<Map<String, dynamic>>> obtenirHistoriquePoids() async {
    try {
      final db = await instance.database;
      return await db.query('poids', orderBy: 'date_prise DESC');
    } catch (e) {
      print('Erreur lors de l\'obtention de l\'historique des poids: $e');
      return [];
    }
  }

  // Obtention de l'historique des poids par période
  Future<List<Map<String, dynamic>>> obtenirHistoriquePoidsParPeriode(String dateDebut, String dateFin) async {
    try {
      final db = await instance.database;
      return await db.query(
        'poids',
        where: 'date_prise BETWEEN ? AND ?',
        whereArgs: [dateDebut, dateFin],
        orderBy: 'date_prise DESC',
      );
    } catch (e) {
      print('Erreur lors de l\'obtention de l\'historique des poids par période: $e');
      return [];
    }
  }

  // Fonction pour obtenir les informations utilisateur
  Future<Map<String, dynamic>?> getUser(String username, String password) async {
    try {
      final db = await instance.database;
      final List<Map<String, dynamic>> results = await db.query(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
        limit: 1,
      );
      if (results.isNotEmpty) {
        return results.first;
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération de l\'utilisateur: $e');
      return null;
    }
  }

  // Fermeture de la base de données
  Future<void> close() async {
    try {
      final db = await instance.database;
      await db.close();
    } catch (e) {
      print('Erreur lors de la fermeture de la base de données: $e');
    }
  }
}
