import 'package:dio/dio.dart';
import 'package:prueba_tecnica_angel_pereira_pikotea/config/config.dart';
import '../models/pokemon_model.dart';
import '../models/pokemon_details_model.dart';

// Datos de origen remoto a través de la API 'pokeapi.co'
class PokemonRemoteDataSource {
  final Dio _dio = Dio();

  Future<List<PokemonModel>> getAllPokemons(int limit, int offset) async {
    final response = await _dio.get('${Environment.apiUrl}pokemon',
        queryParameters: {'limit': limit, 'offset': offset});
    final data = response.data['results'] as List;
    return data.map((json) => PokemonModel.fromJson(json)).toList();
  }

  Future<PokemonDetailsModel> getPokemonDetails(String id) async {
    final response = await _dio.get('${Environment.apiUrl}pokemon/$id');
    return PokemonDetailsModel.fromJson(response.data);
  }
}
