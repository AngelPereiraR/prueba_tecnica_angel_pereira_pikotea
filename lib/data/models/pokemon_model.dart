class PokemonModel {
  final String name;
  final String url;
  bool isFavorite;

  PokemonModel({
    required this.name,
    required this.url,
    required this.isFavorite,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      name: json['name'] as String,
      url: json['url'] as String,
      isFavorite:
          json['isFavorite'] != null ? json['isFavorite'] as bool : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'isFavorite': isFavorite,
    };
  }
}
