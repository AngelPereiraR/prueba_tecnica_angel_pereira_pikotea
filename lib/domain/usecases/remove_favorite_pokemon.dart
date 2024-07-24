import 'package:prueba_tecnica_angel_pereira_pikotea/domain/entities/pokemon.dart';

import '../../domain/repositories/pokemon_repository.dart';

class RemoveFavoritePokemon {
  final PokemonRepository repository;

  RemoveFavoritePokemon(this.repository);

  Future<void> call(Pokemon pokemon) async {
    return repository.removeFavoritePokemon(pokemon);
  }
}
