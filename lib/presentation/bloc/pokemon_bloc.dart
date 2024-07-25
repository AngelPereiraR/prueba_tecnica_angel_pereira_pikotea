import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_tecnica_angel_pereira_pikotea/data/mappers/pokemon_mapper.dart';
import 'package:prueba_tecnica_angel_pereira_pikotea/data/models/pokemon_model.dart';
import 'package:prueba_tecnica_angel_pereira_pikotea/domain/usecases/get_favorite_pokemons.dart';
import 'package:prueba_tecnica_angel_pereira_pikotea/domain/usecases/remove_favorite_pokemon.dart';
import 'package:prueba_tecnica_angel_pereira_pikotea/domain/usecases/save_favorite_pokemon.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/usecases/get_all_pokemons.dart';
import '../../domain/usecases/get_pokemon_details.dart';
import 'pokemon_event.dart';
import 'pokemon_state.dart';

List<Pokemon> _allPokemons = [];
// Verificar si el botón para mostrar solo los pokemons favoritos está seleccionado o no
bool isSelected = false;

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final GetAllPokemons getAllPokemons;
  final GetPokemonDetails getPokemonDetails;
  final SaveFavoritePokemon saveFavoritePokemon;
  final RemoveFavoritePokemon removeFavoritePokemon;
  final GetFavoritePokemons getFavoritePokemons;

  PokemonBloc(
      {required this.getAllPokemons,
      required this.getPokemonDetails,
      required this.getFavoritePokemons,
      required this.removeFavoritePokemon,
      required this.saveFavoritePokemon})
      : super(PokemonInitial()) {
    on<LoadPokemons>((event, emit) async {
      emit(PokemonLoading());
      try {
        if (_allPokemons.isEmpty) {
          // Se obtienen todos los pokemons
          _allPokemons = await getAllPokemons();
        }
        emit(PokemonLoaded(pokemons: _allPokemons, showFavorites: false));
      } catch (e) {
        emit(PokemonError(message: e.toString()));
      }
    });

    on<LoadPokemonDetails>((event, emit) async {
      emit(PokemonLoading());
      try {
        // Se obtiene el pokemon cuyo nombre sea igual al id pasado que tiene el isFavorite
        final pokemonWithFavorite =
            _allPokemons.firstWhere((pokemon) => pokemon.name == event.id);
        // Se obtiene el pokemon original de la API sin el isFavorite
        final originalPokemon = await getPokemonDetails(event.id);
        // Se asigna el isFavorite del pokemon local al pokemon original
        originalPokemon.isFavorite = pokemonWithFavorite.isFavorite;
        emit(PokemonDetailsLoaded(pokemon: originalPokemon));
      } catch (e) {
        emit(PokemonError(message: e.toString()));
      }
    });

    on<FilterFavorites>((event, emit) async {
      emit(PokemonLoading());
      dynamic filteredStringPokemons = [];
      List<Pokemon> filteredPokemons = [];
      if (event.showFavorites) {
        // Se obtienen los pokemons favoritos del local storage
        filteredStringPokemons = getFavoritePokemons();

        // Decodifica el string JSON
        List<dynamic> jsonList = jsonDecode(filteredStringPokemons.toString());

        // Convierte la lista de mapas en una lista de objetos Pokemon
        filteredPokemons = jsonList
            .map((json) => PokemonMapper.fromModel(PokemonModel.fromJson(json)))
            .toList();
      } else {
        filteredPokemons = _allPokemons;
      }
      emit(PokemonLoaded(
          pokemons: filteredPokemons, showFavorites: event.showFavorites));
    });

    on<ToggleFavorite>((event, emit) async {
      emit(PokemonLoading());
      try {
        // Se obtiene el pokemon cuyo nombre sea igual al pokemonId pasado que tiene el isFavorite
        Pokemon pokemonWithFavorite = _allPokemons
            .firstWhere((pokemon) => pokemon.name == event.pokemonId);

        // Si el evento proviene de la pantalla de detalles se asigna el contrario de isFavorite
        if (event.from == "details") {
          pokemonWithFavorite.isFavorite = !pokemonWithFavorite.isFavorite;
        }

        if (pokemonWithFavorite.isFavorite) {
          // Se guarda localmente el pokemon favorito
          await saveFavoritePokemon(pokemonWithFavorite);
          pokemonWithFavorite.isFavorite = !pokemonWithFavorite.isFavorite;
        } else {
          pokemonWithFavorite.isFavorite = !pokemonWithFavorite.isFavorite;
          // Se elimina localmente el pokemon favorito
          await removeFavoritePokemon(pokemonWithFavorite);
        }
      } catch (e) {
        emit(PokemonError(message: e.toString()));
      }
      // Se obtiene el pokemon cuyo nombre sea igual al pokemonId pasado que tiene el isFavorite
      final pokemon =
          _allPokemons.firstWhere((pokemon) => pokemon.name == event.pokemonId);
      // Se asigna el contrario de isFavorite
      pokemon.isFavorite = !pokemon.isFavorite;

      // Se busca el pokemon que coincide en nombre y se asigna el contrario de su isFavorite
      _allPokemons.map((pokemonOriginal) {
        if (pokemonOriginal.name == pokemon.name) {
          pokemonOriginal.isFavorite = !pokemonOriginal.isFavorite;
        }
      });

      emit(PokemonLoaded(pokemons: _allPokemons, showFavorites: false));

      // Si el evento proviene de la pantalla detalles se vuelven a obtener los detalles de ese pokemon y se asigna su isFavorite correspondiente
      if (event.from == "details") {
        try {
          final pokemonWithFavorite = _allPokemons
              .firstWhere((pokemon) => pokemon.name == event.pokemonId);
          final originalPokemon = await getPokemonDetails(event.pokemonId);
          originalPokemon.isFavorite = pokemonWithFavorite.isFavorite;
          emit(PokemonDetailsLoaded(pokemon: originalPokemon));
        } catch (e) {
          emit(PokemonError(message: e.toString()));
        }
      }
    });
  }
}
