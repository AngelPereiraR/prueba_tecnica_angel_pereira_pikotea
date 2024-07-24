import 'package:prueba_tecnica_angel_pereira_pikotea/domain/entities/pokemon_details.dart';

import '../../domain/entities/pokemon.dart';

abstract class PokemonRepository {
  Future<List<Pokemon>> getAllPokemons();
  Future<PokemonDetails> getPokemonDetails(String id);
  void saveFavoritePokemon(Pokemon pokemon);
  void removeFavoritePokemon(Pokemon pokemon);
  List<String> getFavoritePokemons();
}
