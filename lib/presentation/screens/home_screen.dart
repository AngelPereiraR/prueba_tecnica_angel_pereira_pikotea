import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../classes/pokemon.dart';

// Lista inicial de los pokemons (Solo se mantendrá mientras no esté realizada la implementación de la API)
List<Pokemon> originalPokemons = [
  Pokemon(id: 1, name: 'Bulbasaur', isFavorite: true),
  Pokemon(id: 2, name: 'Ivysaur', isFavorite: false),
  Pokemon(id: 3, name: 'Venusaur', isFavorite: false),
  Pokemon(id: 4, name: 'Charmander', isFavorite: true),
  Pokemon(id: 5, name: 'Charmeleon', isFavorite: true),
  Pokemon(id: 6, name: 'Charizard', isFavorite: false),
];

// Lista de los pokemons mostrados (Solo se mantendrá mientras no esté realizada la implementación de la API)
List<Pokemon> displayedPokemons = [];

class HomeScreen extends StatefulWidget {
  static const name = 'home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Verificar si el botón para mostrar solo los pokemons favoritos está seleccionado o no
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    // Asignación de los pokemons mostrados dependiendo si el botón para mostrar solo los pokemons favoritos está seleccionado o no
    displayedPokemons = isSelected
        ? originalPokemons.where((pokemon) => pokemon.isFavorite).toList()
        : originalPokemons;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Pokemon'),
        leading: Container(
          margin: const EdgeInsets.only(left: 15),
          child: Image.asset(
            'assets/pokeball.png',
            fit: BoxFit.contain,
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
                displayedPokemons = isSelected
                    ? originalPokemons
                        .where((pokemon) => pokemon.isFavorite)
                        .toList()
                    : originalPokemons;
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
          )
        ],
      ),
      body: ListView.builder(
        itemCount: displayedPokemons.length,
        itemBuilder: (context, index) {
          final pokemon = displayedPokemons[index];
          return Column(
            children: [
              ListTile(
                title: Row(
                  children: [
                    Image.asset(
                      'assets/pokeball.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(pokemon.name)
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      pokemon.isFavorite = !pokemon.isFavorite;
                    });
                  },
                  icon: pokemon.isFavorite
                      ? const Icon(
                          Icons.star_rounded,
                          size: 40,
                        )
                      : const Icon(
                          Icons.star_border_rounded,
                          size: 40,
                        ),
                  tooltip: isSelected
                      ? 'Desmarcar como favorito'
                      : 'Marcar como favorito',
                ),
                onTap: () {
                  context.push('/pokemon/${pokemon.id}', extra: pokemon);
                },
              ),
              const Divider(
                height: 5,
                thickness: 3,
              )
            ],
          );
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
    final results = displayedPokemons.where(
        (pokemon) => pokemon.name.toLowerCase().contains(query.toLowerCase()));
    return ListView(
      children: results
          .expand((pokemon) => [
                ListTile(
                  title: Row(
                    children: [
                      Image.asset(
                        'assets/pokeball.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(pokemon.name)
                    ],
                  ),
                  onTap: () {
                    context.push('/pokemon/${pokemon.id}', extra: pokemon);
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
  }

  // Recuperación de las sugerencias conforme se va buscando
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    final suggestions = displayedPokemons.where((pokemon) =>
        pokemon.name.toLowerCase().startsWith(query.toLowerCase()));
    return ListView(
      children: suggestions
          .expand((pokemon) => [
                ListTile(
                  title: Row(
                    children: [
                      Image.asset(
                        'assets/pokeball.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(pokemon.name)
                    ],
                  ),
                  onTap: () {
                    context.push('/pokemon/${pokemon.id}', extra: pokemon);
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
