import 'package:flutter_bloc/flutter_bloc.dart';
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

  PokemonBloc({
    required this.getAllPokemons,
    required this.getPokemonDetails,
  }) : super(PokemonInitial()) {
    on<LoadPokemons>((event, emit) async {
      emit(PokemonLoading());
      try {
        if (_allPokemons.isEmpty) {
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
        final pokemonWithFavorite =
            _allPokemons.firstWhere((pokemon) => pokemon.name == event.id);
        final originalPokemon = await getPokemonDetails(event.id);
        originalPokemon.isFavorite = pokemonWithFavorite.isFavorite;
        emit(PokemonDetailsLoaded(pokemon: originalPokemon));
      } catch (e) {
        emit(PokemonError(message: e.toString()));
      }
    });

    on<FilterFavorites>((event, emit) async {
      List<Pokemon> filteredPokemons = [];
      if (event.showFavorites) {
        filteredPokemons =
            _allPokemons.where((pokemon) => pokemon.isFavorite).toList();
      } else {
        filteredPokemons = _allPokemons;
      }
      emit(PokemonLoaded(
          pokemons: filteredPokemons, showFavorites: event.showFavorites));
    });

    on<ToggleFavorite>((event, emit) async {
      try {
        final pokemonWithFavorite = _allPokemons
            .firstWhere((pokemon) => pokemon.name == event.pokemonId);
        pokemonWithFavorite.isFavorite = !pokemonWithFavorite.isFavorite;

        _allPokemons.map((pokemon) => {
              if (pokemon.name == pokemonWithFavorite.name)
                {pokemon = pokemonWithFavorite}
            });
      } catch (e) {
        emit(PokemonError(message: e.toString()));
      }
      if (state is PokemonLoaded) {
        final currentState = state as PokemonLoaded;
        final pokemon = _allPokemons
            .firstWhere((pokemon) => pokemon.name == event.pokemonId);
        pokemon.isFavorite = !pokemon.isFavorite;

        // Emit the updated state
        emit(PokemonLoaded(
            pokemons: currentState.pokemons,
            showFavorites: currentState.showFavorites));
      }
    });
  }
}
