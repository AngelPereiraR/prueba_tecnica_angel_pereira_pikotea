import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/pokemon_bloc.dart';
import '../bloc/pokemon_event.dart';
import '../bloc/pokemon_state.dart';

class HomeScreen extends StatefulWidget {
  static const name = 'home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadPokemons();
  }

  void _loadPokemons() {
    context.read<PokemonBloc>().add(LoadPokemons());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Pokemon'),
        leading: Container(
          margin: const EdgeInsets.all(10),
          child: Image.asset(
            'assets/pokeball.png',
            width: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: PokemonSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Buscar pokemons',
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isSelected = !isSelected;
                BlocProvider.of<PokemonBloc>(context)
                    .add(FilterFavorites(isSelected));
              });
            },
            icon: isSelected
                ? const Icon(
                    Icons.star_rounded,
                  )
                : const Icon(
                    Icons.star_border_rounded,
                  ),
            tooltip: isSelected
                ? 'Mostrar todos los pokemons'
                : 'Mostrar sólo los pokemons favoritos',
          ),
        ],
      ),
      body: BlocBuilder<PokemonBloc, PokemonState>(
        builder: (context, state) {
          if (state is PokemonLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PokemonLoaded) {
            return ListView.builder(
              itemCount: state.pokemons.length,
              itemBuilder: (context, index) {
                final pokemon = state.pokemons[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(pokemon.name),
                      onTap: () {
                        context
                            .read<PokemonBloc>()
                            .add(LoadPokemonDetails(pokemon.name));
                        context.push('/pokemon/${pokemon.name}');
                      },
                      trailing: !isSelected
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  pokemon.isFavorite = !pokemon.isFavorite;
                                  BlocProvider.of<PokemonBloc>(context).add(
                                      ToggleFavorite(pokemon.name, 'home'));
                                });
                              },
                              icon: pokemon.isFavorite
                                  ? const Icon(
                                      Icons.star_rounded,
                                    )
                                  : const Icon(
                                      Icons.star_border_rounded,
                                    ),
                              tooltip: pokemon.isFavorite
                                  ? 'Quitar de favoritos'
                                  : 'Añadir a favoritos',
                            )
                          : null,
                    ),
                    const Divider(
                      height: 5,
                      thickness: 3,
                    ),
                  ],
                );
              },
            );
          } else if (state is PokemonError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}

// Delegador de la búsqueda de pokemons
class PokemonSearchDelegate extends SearchDelegate<String> {
  // Campo del buscador de pokemons
  @override
  String? get searchFieldLabel => 'Buscar pokemon';

  // Acciones del Appbar. Borrar el query escrito
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  // Botón para volver atrás
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  // Recuperación de los resultados tras la búsqueda
  @override
  Widget buildResults(BuildContext context) {
    return BlocBuilder<PokemonBloc, PokemonState>(
      builder: (context, state) {
        if (state is PokemonLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PokemonLoaded) {
          final results = state.pokemons.where((pokemon) =>
              pokemon.name.toLowerCase().contains(query.toLowerCase()));
          return ListView(
            children: results
                .expand((pokemon) => [
                      ListTile(
                        title: Text(pokemon.name),
                        onTap: () {
                          context
                              .read<PokemonBloc>()
                              .add(LoadPokemonDetails(pokemon.name));
                          context.push('/pokemon/${pokemon.name}');
                          close(context, pokemon.name);
                        },
                      ),
                      const Divider(
                        height: 5,
                        thickness: 3,
                      ),
                    ])
                .toList(),
          );
        } else if (state is PokemonError) {
          return Center(child: Text(state.message));
        }
        return Container();
      },
    );
  }

  // Recuperación de las sugerencias conforme se va buscando
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    return BlocBuilder<PokemonBloc, PokemonState>(
      builder: (context, state) {
        if (state is PokemonLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PokemonLoaded) {
          final suggestions = state.pokemons.where((pokemon) =>
              pokemon.name.toLowerCase().startsWith(query.toLowerCase()));
          return ListView(
            children: suggestions
                .expand((pokemon) => [
                      ListTile(
                        title: Text(pokemon.name),
                        onTap: () {
                          context
                              .read<PokemonBloc>()
                              .add(LoadPokemonDetails(pokemon.name));
                          context.push('/pokemon/${pokemon.name}');
                          close(context, pokemon.name);
                        },
                      ),
                      const Divider(
                        height: 5,
                        thickness: 3,
                      ),
                    ])
                .toList(),
          );
        } else if (state is PokemonError) {
          return Center(child: Text(state.message));
        }
        return Container();
      },
    );
  }

  // Tema del appbar de la barra de búsqueda
  @override
  ThemeData appBarTheme(BuildContext context) {
    const seedColor = Color.fromARGB(255, 0, 110, 255);

    const textTheme = TextTheme(
      displayLarge: TextStyle(color: seedColor),
      displayMedium: TextStyle(color: seedColor),
      displaySmall: TextStyle(color: seedColor),
      headlineMedium: TextStyle(color: seedColor),
      headlineSmall: TextStyle(color: seedColor),
      titleLarge: TextStyle(color: seedColor),
      bodyLarge: TextStyle(color: seedColor),
      bodyMedium: TextStyle(color: seedColor),
      bodySmall: TextStyle(color: seedColor),
      labelLarge: TextStyle(color: seedColor),
      titleMedium: TextStyle(color: seedColor),
      titleSmall: TextStyle(color: seedColor),
      labelSmall: TextStyle(color: seedColor),
      headlineLarge: TextStyle(color: seedColor),
      labelMedium: TextStyle(color: seedColor),
    );

    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white70,
        iconTheme: theme.primaryIconTheme.copyWith(color: seedColor),
        titleTextStyle: theme.textTheme.titleLarge,
        toolbarTextStyle: theme.textTheme.bodyMedium,
      ),
      inputDecorationTheme: searchFieldDecorationTheme ??
          InputDecorationTheme(
              hintStyle:
                  searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
              border: InputBorder.none,
              labelStyle: const TextStyle(color: seedColor)),
      textTheme: textTheme,
    );
  }
}
