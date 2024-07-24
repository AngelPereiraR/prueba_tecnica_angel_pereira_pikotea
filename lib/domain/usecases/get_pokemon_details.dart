import '../../domain/repositories/pokemon_repository.dart';
import '../entities/pokemon_details.dart';

class GetPokemonDetails {
  final PokemonRepository repository;

  GetPokemonDetails(this.repository);

  Future<PokemonDetails> call(String id) {
    return repository.getPokemonDetails(id);
  }
}
