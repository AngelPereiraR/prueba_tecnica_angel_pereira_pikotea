import 'package:flutter/material.dart';
import 'package:prueba_tecnica_angel_pereira_pikotea/config/config.dart';
import 'package:prueba_tecnica_angel_pereira_pikotea/config/router/app_router.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      title: 'PokeAPI Pikotea',
    );
  }
}
