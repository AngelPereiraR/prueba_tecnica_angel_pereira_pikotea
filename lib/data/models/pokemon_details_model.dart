class PokemonDetailsModel {
  final int id;
  final String name;
  final String sprites;
  final List<String> abilities;
  final String game;
  bool isFavorite;

  PokemonDetailsModel(
      {required this.id,
      required this.name,
      required this.sprites,
      required this.abilities,
      required this.game,
      required this.isFavorite});

  factory PokemonDetailsModel.fromJson(Map<String, dynamic> json) {
    final abilities = (json['abilities'] as List)
        .map((ability) =>
            (ability['ability'] as Map<String, dynamic>)['name'] as String)
        .toList();
    final game = (json['game_indices'] as List).isNotEmpty
        ? (json['game_indices'][0]['version'] as Map<String, dynamic>)['name']
            as String
        : 'Unknown';

    return PokemonDetailsModel(
      id: json['id'] as int,
      name: json['name'] as String,
      sprites: json['sprites']['front_default'] as String,
      abilities: abilities,
      game: game,
      isFavorite:
          json['isFavorite'] != null ? json['isFavorite'] as bool : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sprites': sprites,
      'abilities': abilities,
      'game': game,
      'isFavorite': isFavorite
    };
  }
}
