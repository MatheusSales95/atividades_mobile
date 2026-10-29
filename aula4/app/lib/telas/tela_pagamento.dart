import 'package:flutter/material.dart';

import '../models/item_cardapio.dart';
import 'tela_finalizacao.dart';

const formasPagamento = [
  'Pix',
  'Cartão de crédito',
  'Cartão de débito',
  'Dinheiro',
];

class TelaPagamento extends StatefulWidget {
  final ItemCardapio prato;
  final ItemCardapio bebida;
  final ItemCardapio sobremesa;

  const TelaPagamento({
    super.key,
    required this.prato,
    required this.bebida,
    required this.sobremesa,
  });

  @override
  State<TelaPagamento> createState() => _TelaPagamentoState();
}

class _TelaPagamentoState extends State<TelaPagamento> {
  String? formaSelecionada;

  void avancar() {
    final forma = formaSelecionada;
    if (forma == null) return;

    // Remove as telas anteriores: da finalização não dá para voltar.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => TelaFinalizacao(
          prato: widget.prato,
          bebida: widget.bebida,
          sobremesa: widget.sobremesa,
          formaPagamento: forma,
        ),
      ),
      (rota) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forma de pagamento')),
      body: ListView(
        children: [
          for (final forma in formasPagamento)
            ListTile(
              title: Text(forma),
              trailing: forma == formaSelecionada
                  ? const Icon(Icons.check)
                  : null,
              onTap: () => setState(() => formaSelecionada = forma),
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
