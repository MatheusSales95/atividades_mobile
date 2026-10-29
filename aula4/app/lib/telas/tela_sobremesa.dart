import 'package:flutter/material.dart';

import '../models/item_cardapio.dart';
import '../utils/formatar_valor.dart';
import 'tela_pagamento.dart';

const sobremesas = [
  ItemCardapio('Pudim', 12.00),
  ItemCardapio('Sorvete', 10.00),
  ItemCardapio('Mousse de chocolate', 11.50),
];

class TelaSobremesa extends StatefulWidget {
  final ItemCardapio prato;
  final ItemCardapio bebida;

  const TelaSobremesa({super.key, required this.prato, required this.bebida});

  @override
  State<TelaSobremesa> createState() => _TelaSobremesaState();
}

class _TelaSobremesaState extends State<TelaSobremesa> {
  ItemCardapio? sobremesaSelecionada;

  void avancar() {
    final sobremesa = sobremesaSelecionada;
    if (sobremesa == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPagamento(
          prato: widget.prato,
          bebida: widget.bebida,
          sobremesa: sobremesa,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobremesa')),
      body: ListView(
        children: [
          for (final item in sobremesas)
            ListTile(
              title: Text(item.nome),
              subtitle: Text(formatarValor(item.valor)),
              trailing: item == sobremesaSelecionada
                  ? const Icon(Icons.check)
                  : null,
              onTap: () => setState(() => sobremesaSelecionada = item),
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
