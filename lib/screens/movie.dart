import 'package:flutter/material.dart';
import 'package:flutterdiplomfr/controllers/movie.dart';
import 'package:flutterdiplomfr/models/movie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutterdiplomfr/controllers/favourites.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({Key? key, required this.movieId}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<Film> _filmFuture;
  final Color _backgroundColor = const Color(0xFF212121);
  final Color _textColor = Colors.white;
  final Color _accentColor = Color.fromARGB(255, 0, 38, 255);
  final Color _descriptionColor = Color(0xFF303030);

  late bool _isFavorite;
  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();

    _databaseHelper = DatabaseHelper(); // Crée une instance de DatabaseHelper
    _initializeDatabase(); // Initialise la base de données

    _isFavorite = false;
    _filmFuture = fetchFilm(widget.movieId);
  }

  void _initializeDatabase() async {
    try {
      await _databaseHelper.initDatabase();
      _checkFavoriteStatus();
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  Future<void> _checkFavoriteStatus() async {
    final isAlreadyFavorite =
        await _databaseHelper.isFavoriteMovie(widget.movieId);
    setState(() {
      _isFavorite = isAlreadyFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        title: Text(
          'Détails sur le film',
          style: GoogleFonts.playfairDisplay(
            fontSize: 32,
            color: _textColor,
          ),
        ),
      ),
      body: FutureBuilder<Film>(
        future: _filmFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Affiche un indicateur de chargement tant que les données sont récupérées
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Si une erreur s'est produite lors de la récupération des données, affiche un message d'erreur
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            // Si les données sont récupérées avec succès, affiche les détails du film
            final film = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(film),
                  _buildBody(film),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildHeader(Film film) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(film.posterUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            _backgroundColor.withOpacity(0.6),
            BlendMode.darken,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.bottomLeft,
        child: Text(
          film.title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            color: _textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(Film film) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Date de sortie: ${film.date}",
            style: GoogleFonts.openSans(
              fontSize: 16,
              color: _descriptionColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            film.description,
            style: GoogleFonts.openSans(
              fontSize: 16,
              color: _descriptionColor,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _toggleFavorite(film);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: _isFavorite ? Colors.red : _accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_isFavorite ? Icons.remove : Icons.favorite),
                const SizedBox(width: 10),
                Text(
                  _isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(Film film) async {
    final isAlreadyFavorite = await _databaseHelper.isFavoriteMovie(film.id);

    setState(() {
      _isFavorite = !isAlreadyFavorite;
    });

    if (!isAlreadyFavorite) {
      await _databaseHelper.addFavoriteMovie(FavoriteMovie.fromFilm(film));
    } else {
      await _databaseHelper.removeFavoriteMovie(film.id);
    }
  }
}
