import 'package:flutter/material.dart';

import '../models/item_cardapio.dart';
import '../utils/formatar_valor.dart';
import 'tela_prato_principal.dart';

class TelaFinalizacao extends StatelessWidget {
  final ItemCardapio prato;
  final ItemCardapio bebida;
  final ItemCardapio sobremesa;
  final String formaPagamento;

  const TelaFinalizacao({
    super.key,
    required this.prato,
    required this.bebida,
    required this.sobremesa,
    required this.formaPagamento,
  });

  @override
  Widget build(BuildContext context) {
    final total = prato.valor + bebida.valor + sobremesa.valor;

    return Scaffold(
      appBar: AppBar(title: const Text('Finalização do pedido')),
      body: ListView(
        children: [
          for (final item in [prato, bebida, sobremesa])
            ListTile(
              title: Text(item.nome),
              trailing: Text(formatarValor(item.valor)),
            ),
          ListTile(
            title: const Text('Total'),
            trailing: Text(formatarValor(total)),
          ),
          ListTile(
            title: const Text('Forma de pagamento'),
            trailing: Text(formaPagamento),
          ),
          ElevatedButton(
            // Tela inicial nova, com as escolhas zeradas.
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const TelaPratoPrincipal(),
              ),
              (rota) => false,
            ),
            child: const Text('Novo pedido'),
          ),
        ],
      ),
    );
  }
}
