import 'package:flutter/material.dart';

import '../models/item_cardapio.dart';
import '../utils/formatar_valor.dart';
import 'tela_bebida.dart';

const pratos = [
  ItemCardapio('Feijoada', 35.90),
  ItemCardapio('Lasanha', 32.50),
  ItemCardapio('Frango grelhado', 28.00),
];

class TelaPratoPrincipal extends StatefulWidget {
  const TelaPratoPrincipal({super.key});

  @override
  State<TelaPratoPrincipal> createState() => _TelaPratoPrincipalState();
}

class _TelaPratoPrincipalState extends State<TelaPratoPrincipal> {
  ItemCardapio? pratoSelecionado;

  void avancar() {
    final prato = pratoSelecionado;
    if (prato == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TelaBebida(prato: prato)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prato principal')),
      body: ListView(
        children: [
          for (final item in pratos)
            ListTile(
              title: Text(item.nome),
              subtitle: Text(formatarValor(item.valor)),
              trailing: item == pratoSelecionado
                  ? const Icon(Icons.check)
                  : null,
              onTap: () => setState(() => pratoSelecionado = item),
            ),
          ElevatedButton(onPressed: avancar, child: const Text('Avançar')),
        ],
      ),
    );
  }
}
