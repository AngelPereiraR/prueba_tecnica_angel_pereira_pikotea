import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/pokemon.dart';

class PokemonLocalDataSource {
  final SharedPreferences sharedPreferences;

  PokemonLocalDataSource({required this.sharedPreferences});

  Future<void> saveFavoritePokemon(Pokemon pokemon) async {
    final favorites = sharedPreferences.getStringList('favorites') ?? [];
    if (!favorites.contains(pokemon.toString())) {
      favorites.add(pokemon.toString());
      await sharedPreferences.setStringList('favorites', favorites);
    }
  }

  Future<void> removeFavoritePokemon(Pokemon pokemon) async {
    final favorites = sharedPreferences.getStringList('favorites') ?? [];
    favorites.remove(pokemon.toString());
    await sharedPreferences.setStringList('favorites', favorites);
  }

  List<String> getFavoritePokemons() {
    return sharedPreferences.getStringList('favorites') ?? [];
  }
}