class Film {
  String title;
  String description;
  String posterUrl;
  List<String> actors;

  Film(
      {this.title = "",
      this.description = "",
      this.posterUrl = "",
      this.actors = const []});
}
