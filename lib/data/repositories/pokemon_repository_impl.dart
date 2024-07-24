import 'dart:convert';

import 'package:prueba_tecnica_angel_pereira_pikotea/domain/entities/pokemon_details.dart';

import '../../data/datasources/pokemon_remote_datasource.dart';
import '../../data/datasources/pokemon_local_datasource.dart';
import '../../data/mappers/pokemon_mapper.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../models/pokemon_model.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;
  final PokemonLocalDataSource localDataSource;

  PokemonRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Pokemon>> getAllPokemons() async {
    // Obtén todos los pokemons desde el remoteDataSource
    List<PokemonModel> models = await remoteDataSource.getAllPokemons(1000, 0);

    // Obtén los pokemons favoritos desde el localDataSource
    final favoritePokemons = getFavoritePokemons();

    // Decodifica el string JSON
    List<dynamic> jsonList = jsonDecode(favoritePokemons.toString());

    // Convierte la lista de mapas en una lista de objetos PokemonModel
    List<PokemonModel> filteredPokemonsModels =
        jsonList.map((json) => PokemonModel.fromJson(json)).toList();

    // Actualiza el estado de 'isFavorite' en los modelos originales
    models = models.map((pokemonModel) {
      for (PokemonModel pokemon in filteredPokemonsModels) {
        if (pokemonModel.name == pokemon.name) {
          // Asumiendo que el nombre es único para cada Pokemon
          pokemonModel.isFavorite = pokemon.isFavorite;
          break;
        }
      }
      return pokemonModel;
    }).toList();

    // Mapea los modelos actualizados a la entidad Pokemon
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
