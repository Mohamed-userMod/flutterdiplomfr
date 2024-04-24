import 'package:flutter/material.dart';
import 'package:flutterdiplomfr/screens/favourites.dart';
import 'screens/movie.dart';
import 'models/movie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Film monFilm = Film(
    title: 'Film de test',
    description: 'Un film épique de fantasy réalisé par Peter Jackson.',
    posterUrl:
        'https://img.freepik.com/free-vector/hand-drawn-halloween-party-flyer-template_23-2148260494.jpg?t=st=1713949903~exp=1713953503~hmac=6a2abbbd0d895581dcf6b310a387f8e18662ff450bb4f5bf2834fe4c7ca34517&w=740',
    actors: ['Elijah Wood', 'Ian McKellen', 'Viggo Mortensen'],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Application',
      routes: {
        '/': (context) => MaPagePrincipale(),
        '/film_detail': (context) => MovieDetailScreen(movieId: 3896198),
        '/favorites': (context) => FavoritesPage(),
      },
    );
  }
}

class MaPagePrincipale extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ma Page Principale'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/film_detail');
              },
              child: Text('Afficher les détails du film'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/favorites');
              },
              child: Text('Afficher les favoris'),
            ),
          ],
        ),
      ),
    );
  }
}
