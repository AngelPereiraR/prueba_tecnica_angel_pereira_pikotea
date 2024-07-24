import '../../domain/repositories/pokemon_repository.dart';

class GetFavoritePokemons {
  final PokemonRepository repository;

  GetFavoritePokemons(this.repository);

  List<String> call() {
    return repository.getFavoritePokemons();
  }
}
