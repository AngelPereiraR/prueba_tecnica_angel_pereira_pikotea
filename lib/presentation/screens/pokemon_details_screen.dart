import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_tecnica_angel_pereira_pikotea/presentation/bloc/pokemon_event.dart';
import '../bloc/pokemon_bloc.dart';
import '../bloc/pokemon_state.dart';

class PokemonDetailsScreen extends StatefulWidget {
  static const name = 'pokemon-details-screen';
  final String id;

  const PokemonDetailsScreen({super.key, required this.id});

  @override
  State<PokemonDetailsScreen> createState() => _PokemonDetailsScreenState();
}

class _PokemonDetailsScreenState extends State<PokemonDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    const yellowSeedColor = Color.fromARGB(255, 255, 230, 0);

    // Usar WillPopScope para manejar la navegación hacia atrás
    return PopScope(
      onPopInvoked: (_) {
        // Disparar el evento LoadPokemons cuando se vuelve a la pantalla anterior
        context.read<PokemonBloc>().add(FilterFavorites(isSelected));
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalles del Pokémon'),
        ),
        body: BlocBuilder<PokemonBloc, PokemonState>(
          builder: (context, state) {
            if (state is PokemonLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PokemonDetailsLoaded) {
              final pokemon = state.pokemon;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagen del Pokémon
                      pokemon.sprites.isNotEmpty
                          ? Image.network(pokemon.sprites,
                              width: 100, height: 100, fit: BoxFit.cover)
                          : Container(), // Puedes usar un widget placeholder si es necesario

                      const SizedBox(height: 16),

                      // Nombre del Pokémon
                      Text(
                        'Nombre: ${pokemon.name}',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),

                      const SizedBox(height: 16),

                      // ID del Pokémon
                      Text(
                        'ID: ${pokemon.id}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),

                      const SizedBox(height: 16),

                      // Habilidades del Pokémon
                      Text(
                        'Habilidades:',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      for (var ability in pokemon.abilities)
                        Text(
                          '- $ability',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),

                      const SizedBox(height: 16),

                      // Juego en el que aparece el Pokémon
                      Text(
                        'Primer juego donde aparece: ${pokemon.game}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),

                      const SizedBox(height: 16),

                      // Estado de Favorito
                      Row(
                        children: [
                          const Text('Elije si es pokemon favorito o no:'),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                pokemon.isFavorite = !pokemon.isFavorite;
                                BlocProvider.of<PokemonBloc>(context).add(
                                    ToggleFavorite(pokemon.name, 'details'));
                              });
                            },
                            icon: pokemon.isFavorite
                                ? const Icon(
                                    Icons.star_rounded,
                                    color: yellowSeedColor,
                                  )
                                : const Icon(
                                    Icons.star_border_rounded,
                                    color: yellowSeedColor,
                                  ),
                            tooltip: pokemon.isFavorite
                                ? 'Quitar de favoritos'
                                : 'Añadir a favoritos',
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            } else if (state is PokemonError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
