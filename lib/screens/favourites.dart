import 'package:flutter/material.dart';
import 'package:flutterdiplomfr/controllers/favourites.dart';
import 'package:flutterdiplomfr/models/movie.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late List<FavoriteMovie> _favoriteMovies = [];
  late DatabaseHelper _databaseHelper;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _initializeDatabase();
  }

  void _initializeDatabase() async {
    try {
      await _databaseHelper.initDatabase();
      print('Initialized');
      _loadFavoriteMovies();
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  Future<void> _loadFavoriteMovies() async {
    print("Called");
    try {
      final favorites = await _databaseHelper.getFavoriteMovies();
      print("Voici les favoris $favorites");
      setState(() {
        _favoriteMovies = favorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoris'),
      ),
      body: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator(), // Affichez un indicateur de chargement si les favoris sont en cours de chargement
            )
          : _favoriteMovies.isEmpty
              ? Center(
                  child: Text(
                    "Aucun favoris pour l'instant.",
                    style: TextStyle(fontSize: 18.0),
                  ),
                )
              : ListView.builder(
                  itemCount: _favoriteMovies.length,
                  itemBuilder: (context, index) {
                    final movie = _favoriteMovies[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        elevation: 4.0,
                        margin: EdgeInsets.symmetric(horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12.0),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              movie.posterUrl,
                              width: 80.0,
                              height: 120.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            movie.title,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            movie.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[700],
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              await _databaseHelper
                                  .removeFavoriteMovie(movie.id);
                              _loadFavoriteMovies();
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
