import 'package:equatable/equatable.dart';
import 'package:prueba_tecnica_angel_pereira_pikotea/domain/entities/pokemon_details.dart';
import '../../domain/entities/pokemon.dart';

abstract class PokemonState extends Equatable {
  @override
  List<Object> get props => [];
}

class PokemonInitial extends PokemonState {}

class PokemonLoading extends PokemonState {}

class PokemonLoaded extends PokemonState {
  List<Pokemon> pokemons;
  bool showFavorites;

  PokemonLoaded({required this.pokemons, required this.showFavorites});

  @override
  List<Object> get props => [pokemons, showFavorites];
}

class PokemonDetailsLoaded extends PokemonState {
  PokemonDetails pokemon;

  PokemonDetailsLoaded({required this.pokemon});

  @override
  List<Object> get props => [pokemon];
}

class PokemonError extends PokemonState {
  final String message;

  PokemonError({required this.message});

  @override
  List<Object> get props => [message];
}
