import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_tecnica_angel_pereira_pikotea/config/config.dart';
import 'package:prueba_tecnica_angel_pereira_pikotea/config/router/app_router.dart';
import 'package:prueba_tecnica_angel_pereira_pikotea/domain/usecases/get_favorite_pokemons.dart';
import 'package:prueba_tecnica_angel_pereira_pikotea/domain/usecases/remove_favorite_pokemon.dart';
import 'package:prueba_tecnica_angel_pereira_pikotea/domain/usecases/save_favorite_pokemon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasources/pokemon_local_datasource.dart';
import 'data/datasources/pokemon_remote_datasource.dart';
import 'data/repositories/pokemon_repository_impl.dart';
import 'domain/usecases/get_all_pokemons.dart';
import 'domain/usecases/get_pokemon_details.dart';
import 'presentation/bloc/pokemon_bloc.dart';
import 'presentation/bloc/pokemon_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  final remoteDataSource = PokemonRemoteDataSource();
  final localDataSource =
      PokemonLocalDataSource(sharedPreferences: sharedPreferences);
  final repository = PokemonRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final PokemonRepositoryImpl? repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PokemonBloc(
              getAllPokemons: GetAllPokemons(repository!),
              getPokemonDetails: GetPokemonDetails(repository!),
              getFavoritePokemons: GetFavoritePokemons(repository!),
              removeFavoritePokemon: RemoveFavoritePokemon(repository!),
              saveFavoritePokemon: SaveFavoritePokemon(repository!))
            ..add(LoadPokemons()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
        theme: AppTheme().getTheme(),
        title: 'PokeAPI Pikotea',
      ),
    );
  }
}
