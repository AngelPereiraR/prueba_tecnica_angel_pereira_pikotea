import 'package:prueba_tecnica_angel_pereira_pikotea/domain/entities/pokemon_details.dart';

import '../../data/datasources/pokemon_remote_datasource.dart';
import '../../data/datasources/pokemon_local_datasource.dart';
import '../../data/mappers/pokemon_mapper.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/pokemon_repository.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;
  final PokemonLocalDataSource localDataSource;

  PokemonRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Pokemon>> getAllPokemons() async {
    final models = await remoteDataSource.getAllPokemons(1000, 0);
    return models.map(PokemonMapper.fromModel).toList();
  }

  @override
  Future<PokemonDetails> getPokemonDetails(String id) async {
    final model = await remoteDataSource.getPokemonDetails(id);
    return PokemonMapper.fromDetailsModel(model);
  }

  @override
  Future<void> saveFavoritePokemon(Pokemon pokemon) {
    return localDataSource.saveFavoritePokemon(pokemon);
  }

  @override
  Future<void> removeFavoritePokemon(Pokemon pokemon) {
    return localDataSource.removeFavoritePokemon(pokemon);
  }

  @override
  List<String> getFavoritePokemons() {
    return localDataSource.getFavoritePokemons();
  }
}
