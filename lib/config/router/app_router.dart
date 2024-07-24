import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/screens.dart';

// Clave necesaria para que cuando se actualice el provider, se inicie un nuevo widget
final navigatorKey = GlobalKey<NavigatorState>();
// Necesitamos acceder a la localización previa del router. De otra manera, empezaría desde '/' en la reconstrucción del widget.
GoRouter? _previousRouter;

final appRouter = GoRouter(
    initialLocation:
        _previousRouter?.routerDelegate.currentConfiguration.fullPath,
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/',
        name: HomeScreen.name,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/pokemon/:id',
        name: PokemonDetailsScreen.name,
        builder: (context, state) {
          final pokemonId = state.pathParameters['id'] ?? '0';
          return PokemonDetailsScreen(id: pokemonId);
        },
      ),
    ]);
