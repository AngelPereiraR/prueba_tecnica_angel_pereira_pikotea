import '../../domain/entities/pokemon.dart';
import '../../domain/entities/pokemon_details.dart';
import '../models/pokemon_model.dart';
import '../models/pokemon_details_model.dart';

class PokemonMapper {
  static Pokemon fromModel(PokemonModel model) {
    return Pokemon(
      name: model.name,
      url: model.url,
      isFavorite: model.isFavorite,
    );
  }

  static PokemonDetails fromDetailsModel(PokemonDetailsModel model) {
    return PokemonDetails(
        id: model.id,
        name: model.name,
        sprites: model.sprites,
        abilities: model.abilities,
        game: model.game,
        isFavorite: model.isFavorite);
  }

  static PokemonModel toModel(Pokemon pokemon) {
    return PokemonModel(
      name: pokemon.name,
      url: pokemon.url,
      isFavorite: pokemon.isFavorite,
    );
  }

  static PokemonDetailsModel toDetailsModel(PokemonDetails details) {
    return PokemonDetailsModel(
        id: details.id,
        name: details.name,
        sprites: details.sprites,
        abilities: details.abilities,
        game: details.game,
        isFavorite: details.isFavorite);
  }
}
