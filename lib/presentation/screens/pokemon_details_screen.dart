import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prueba_tecnica_angel_pereira_pikotea/presentation/classes/pokemon.dart';

class PokemonDetailsScreen extends StatelessWidget {
  static const name = 'pokemon-details-screen';
  // Datos del pokemon (Solo se mantendrá mientras no esté realizada la implementación de la API)
  final Pokemon pokemon;
  // Id del pokemon seleccionado
  final int id;

  const PokemonDetailsScreen(
      {super.key, required this.pokemon, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del pokemon: ${pokemon.name}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            // Detalles del pokemon seleccionado
            Text('ID del pokemon: ${pokemon.id}'),
            const SizedBox(
              height: 10,
            ),
            Text('Nombre del pokemon: ${pokemon.name}'),
            const SizedBox(
              height: 10,
            ),
            Text('¿Es un pokemon favorito?: ${pokemon.isFavorite}')
          ],
        ),
      ),
    );
  }
}
