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

      await db.execute('''
        CREATE TABLE poids (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          valeur_poids REAL,
          date_prise TEXT
        )
      ''');
      print('Table poids créée');

      await db.execute('''
        CREATE TABLE imc (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          valeur_taille INTEGER,
          valeur_poids REAL,
          age INTEGER,
          valeur_imc REAL
        )
      ''');
      print('Table IMC créée');

    } catch (e) {
      print('Erreur lors de la création des tables: $e');
    }
  }

  // Fonction pour calculer l'IMC et insérer le résultat dans la table IMC
  Future<double> calculerEtEnregistrerIMC(int taille, double poids, int age) async {
    try {
      // Calcul de l'IMC
      double tailleEnMetres = taille / 100;
      double imc = poids / (tailleEnMetres * tailleEnMetres);

      // Insertion du résultat dans la table IMC
      final db = await instance.database;
      await db.insert('imc', {
        'valeur_taille': taille,
        'valeur_poids': poids,
        'age': age,
        'valeur_imc': imc,
      });

      return imc;
    } catch (e) {
      print('Erreur lors du calcul de l\'IMC: $e');
      return 0.0; // Retourne 0.0 en cas d'erreur
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

