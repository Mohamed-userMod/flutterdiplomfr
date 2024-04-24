class Film {
  int id;
  String title;
  String description;
  String posterUrl;
  List<String> actors;

  Film(
      {this.id = 0,
      this.title = "",
      this.description = "",
      this.posterUrl = "",
      this.actors = const []});
}
