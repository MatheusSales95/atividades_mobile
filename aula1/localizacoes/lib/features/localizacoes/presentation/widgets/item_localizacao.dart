import 'package:flutter/material.dart';
import 'package:localizacoes/features/localizacoes/models/localizacao.dart';

class ItemLocalizacao extends StatelessWidget {
  const ItemLocalizacao({super.key, required this.localizacao});

  final Localizacao localizacao;

  static String _formatarData(DateTime data) {
    String dois(int valor) => valor.toString().padLeft(2, '0');
    return '${dois(data.day)}/${dois(data.month)}/${data.year} '
        '${dois(data.hour)}:${dois(data.minute)}:${dois(data.second)}';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_formatarData(localizacao.instante.toLocal())),
      subtitle: Text(
        'Latitude: ${localizacao.latitude.toStringAsFixed(6)}\n'
        'Longitude: ${localizacao.longitude.toStringAsFixed(6)}\n'
        'Precisão: ${localizacao.precisao.toStringAsFixed(1)} m',
      ),
    );
  }
}
