class Pokemon {
  final String name;
  final String url;
  bool isFavorite;

  Pokemon({required this.name, required this.url, required this.isFavorite});

  @override
  String toString() {
    return '{"name":"$name","url":"$url","isFavorite":$isFavorite}';
  }
}
