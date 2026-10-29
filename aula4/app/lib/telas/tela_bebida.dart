import 'package:flutter/material.dart';

import '../models/item_cardapio.dart';
import '../utils/formatar_valor.dart';
import 'tela_sobremesa.dart';

const bebidas = [
  ItemCardapio('Refrigerante', 6.00),
  ItemCardapio('Suco natural', 8.50),
  ItemCardapio('Água', 4.00),
];

class TelaBebida extends StatefulWidget {
  final ItemCardapio prato;

  const TelaBebida({super.key, required this.prato});

  @override
  State<TelaBebida> createState() => _TelaBebidaState();
}

class _TelaBebidaState extends State<TelaBebida> {
  ItemCardapio? bebidaSelecionada;

  void avancar() {
    final bebida = bebidaSelecionada;
    if (bebida == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TelaSobremesa(prato: widget.prato, bebida: bebida),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bebida')),
      body: ListView(
        children: [
          for (final item in bebidas)
            ListTile(
              title: Text(item.nome),
              subtitle: Text(formatarValor(item.valor)),
              trailing: item == bebidaSelecionada
                  ? const Icon(Icons.check)
                  : null,
              onTap: () => setState(() => bebidaSelecionada = item),
            ),
          ElevatedButton(onPressed: avancar, child: const Text('Avançar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Voltar'),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.popUntil(context, (rota) => rota.isFirst),
            child: const Text('Voltar ao início'),
          ),
        ],
      ),
    );
  }
}
