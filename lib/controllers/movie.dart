import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutterdiplomfr/models/movie.dart';

Future<Film> fetchFilm(int movieId) async {
  final String apiKey =
      'YOUR_API_KEY'; // Remplacez YOUR_API_KEY par votre propre clé API OMDB
  // final String apiUrl = 'http://www.omdbapi.com/?apikey=$apiKey&i=tt$movieId';
  final String apiUrl = "https://www.omdbapi.com/?i=tt$movieId&apikey=72ec47ea";

  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    // Si la requête est réussie
    final Map<String, dynamic> responseData = json.decode(response.body);
    return Film(
      id: movieId,
      title: responseData['Title'] ?? 'Titre inconnu',
      description: responseData['Plot'] ?? 'Description inconnue',
      posterUrl: responseData['Poster'] ?? 'https://via.placeholder.com/150',
      actors: (responseData['Actors'] as String?)?.split(',').toList() ?? [],
    );
  } else {
    throw Exception('Failed to load film');
  }
}
