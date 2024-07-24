import 'package:equatable/equatable.dart';

abstract class PokemonEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPokemons extends PokemonEvent {}

class LoadPokemonDetails extends PokemonEvent {
  final String id;

  LoadPokemonDetails(this.id);

  @override
  List<Object> get props => [id];
}

class FilterFavorites extends PokemonEvent {
  final bool showFavorites;

  FilterFavorites(this.showFavorites);
}

class ToggleFavorite extends PokemonEvent {
  final String pokemonId;

  ToggleFavorite(this.pokemonId);

  @override
  List<Object> get props => [pokemonId];
}
