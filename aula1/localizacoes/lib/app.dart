import 'package:flutter/material.dart';
import 'package:localizacoes/features/localizacoes/presentation/screens/tela_coleta.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Localizações', home: TelaColeta());
  }
}
