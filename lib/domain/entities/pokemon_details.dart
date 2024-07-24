class PokemonDetails {
  final int id;
  final String name;
  final String sprites;
  final List<String> abilities;
  final String game;
  bool isFavorite;

  PokemonDetails({
    required this.id,
    required this.name,
    required this.sprites,
    required this.abilities,
    required this.game,
    required this.isFavorite,
  });
}
