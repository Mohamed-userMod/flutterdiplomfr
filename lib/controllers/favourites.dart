import 'package:sqflite/sqflite.dart';
import "../models/movie.dart";

class FavoriteMovie {
  final int id;
  final String title;
  final String date;
  final String description;
  final String posterUrl;

  FavoriteMovie({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.posterUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'description': description,
      'posterUrl': posterUrl,
    };
  }

  factory FavoriteMovie.fromFilm(Film film) {
    return FavoriteMovie(
      id: film.id,
      title: film.title,
      date: film.date,
      description: film.description,
      posterUrl: film.posterUrl,
    );
  }
}

class DatabaseHelper {
  late Database _database;

  // final dbname = "";

  Future<void> initDatabase() async {
    _database = await openDatabase(
      'database_test_test.db',
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE favorite_movies(id INTEGER PRIMARY KEY, title TEXT, description TEXT, date TEXT, posterUrl TEXT)',
        );
      },
    );
  }

  Future<void> addFavoriteMovie(FavoriteMovie movie) async {
    try {
      await _database.insert('favorite_movies', movie.toMap());
      print('Movie added to favorites successfully.');
    } catch (e) {
      print('Error adding movie to favorites: $e');
    }
  }

  Future<void> removeFavoriteMovie(int id) async {
    try {
      await _database.delete(
        'favorite_movies',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Movie removed from favorites successfully.');
    } catch (e) {
      print('Error removing movie from favorites: $e');
    }
  }

  Future<List<FavoriteMovie>> getFavoriteMovies() async {
    try {
      print("Fetching favorite movies from the database...");
      final List<Map<String, dynamic>> maps =
          await _database.query('favorite_movies');
      print("Retrieved data from the database:");
      print(maps);

      print("Generating list of favorite movies...");
      final favoriteMovies = List.generate(maps.length, (index) {
        return FavoriteMovie(
          id: maps[index]['id'],
          title: maps[index]['title'],
          date: maps[index]['date'],
          description: maps[index]['description'],
          posterUrl: maps[index]['posterUrl'],
        );
      });
      print("List of favorite movies generated:");
      print(favoriteMovies);

      return favoriteMovies;
    } catch (e) {
      print("An error occurred while fetching favorite movies: $e");
      return []; // Return an empty list if there's an error
    }
  }

  Future<bool> isFavoriteMovie(int id) async {
    final List<Map<String, dynamic>> result = await _database.query(
      'favorite_movies',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }
}
