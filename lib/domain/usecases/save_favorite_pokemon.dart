import 'package:prueba_tecnica_angel_pereira_pikotea/domain/entities/pokemon.dart';

import '../../domain/repositories/pokemon_repository.dart';

class SaveFavoritePokemon {
  final PokemonRepository repository;

  SaveFavoritePokemon(this.repository);

  Future<void> call(Pokemon pokemon) async {
    return repository.saveFavoritePokemon(pokemon);
  }
}
