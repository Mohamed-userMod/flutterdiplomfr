class Film {
  int id;
  String title;
  String date;
  String description;
  String posterUrl;
  List<String> actors;

  Film(
      {this.id = 0,
      this.title = "",
      this.date = "",
      this.description = "",
      this.posterUrl = "",
      this.actors = const []});
}
