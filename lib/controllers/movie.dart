import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutterdiplomfr/models/movie.dart';

Future<Film> fetchFilm(int movieId) async {
  const String apiKey = '72ec47ea';
  final String apiUrl = "https://www.omdbapi.com/?i=tt$movieId&apikey=$apiKey";

  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    return Film(
      id: movieId,
      title: responseData['Title'] ?? 'Titre inconnu',
      date: responseData['Released'] ?? 'Date inconnu',
      description: responseData['Plot'] ?? 'Description inconnue',
      posterUrl: responseData['Poster'] ?? 'https://via.placeholder.com/150',
      actors: (responseData['Actors'] as String?)?.split(',').toList() ?? [],
    );
  } else {
    throw Exception('Failed to load film');
  }
}
