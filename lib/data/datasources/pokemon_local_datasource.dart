import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/pokemon.dart';

class PokemonLocalDataSource {
  final SharedPreferences sharedPreferences;

  PokemonLocalDataSource({required this.sharedPreferences});

  Future<void> saveFavoritePokemon(Pokemon pokemon) async {
    // print('Añadir');
    // print(pokemon.toString());
    final favorites = sharedPreferences.getStringList('favorites') ?? [];
    if (!favorites.contains(pokemon.toString())) {
      favorites.add(pokemon.toString());
      await sharedPreferences.setStringList('favorites', favorites);
    }
  }

  Future<void> removeFavoritePokemon(Pokemon pokemon) async {
    // print('Eliminar');
    // print(pokemon.toString());
    final favorites = sharedPreferences.getStringList('favorites') ?? [];
    favorites.removeWhere((pokemonString) {
      // print(pokemonString);
      return pokemonString == pokemon.toString();
    });
    await sharedPreferences.setStringList('favorites', favorites);
  }

  List<String> getFavoritePokemons() {
    // sharedPreferences.remove('favorites');
    return sharedPreferences.getStringList('favorites') ?? [];
  }
}
