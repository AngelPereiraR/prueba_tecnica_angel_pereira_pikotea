import 'package:dio/dio.dart';
import '../models/pokemon_model.dart';
import '../models/pokemon_details_model.dart';

class PokemonRemoteDataSource {
  final Dio _dio = Dio();

  Future<List<PokemonModel>> getAllPokemons(int limit, int offset) async {
    final response = await _dio.get('https://pokeapi.co/api/v2/pokemon',
        queryParameters: {'limit': limit, 'offset': offset});
    final data = response.data['results'] as List;
    return data.map((json) => PokemonModel.fromJson(json)).toList();
  }

  Future<PokemonDetailsModel> getPokemonDetails(String id) async {
    final response = await _dio.get('https://pokeapi.co/api/v2/pokemon/$id');
    return PokemonDetailsModel.fromJson(response.data);
  }
}
