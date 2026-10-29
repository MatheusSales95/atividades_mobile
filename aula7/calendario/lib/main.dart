import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: TelaCompromissos()));
}

class TelaCompromissos extends StatefulWidget {
  const TelaCompromissos({super.key});

  @override
  State<TelaCompromissos> createState() => _TelaCompromissosState();
}

class _TelaCompromissosState extends State<TelaCompromissos> {
  final _plugin = DeviceCalendarPlugin();

  List<Event> _compromissos = [];
  Map<String?, String?> _calendarios = {};
  bool _carregando = false;
  String _mensagem = '';

  // Data e hora como aparecem na agenda, no fuso do próprio evento
  // (o Android guarda os eventos de dia inteiro em UTC).
  DateTime _dataHora(DateTime data) =>
      DateTime(data.year, data.month, data.day, data.hour, data.minute);

  String _formatar(DateTime data, bool diaInteiro) =>
      _dataHora(data).toString().substring(0, diaInteiro ? 10 : 16);

  Future<void> _consultar() async {
    setState(() {
      _carregando = true;
      _compromissos = [];
      _mensagem = '';
    });

    try {
      var permissao = await _plugin.hasPermissions();
      if (permissao.data != true) {
        permissao = await _plugin.requestPermissions();
      }
      if (permissao.data != true) {
        _mensagem = 'Acesso ao calendário negado.';
        return;
      }

      final calendarios = await _plugin.retrieveCalendars();
      if (!calendarios.isSuccess) throw Exception();

      final hoje = DateTime.now();
      final inicio = DateTime(hoje.year, hoje.month, hoje.day);
      final fim = DateTime(hoje.year, hoje.month, hoje.day + 7);

      final compromissos = <Event>[];
      for (final calendario in calendarios.data!) {
        final eventos = await _plugin.retrieveEvents(
          calendario.id,
          RetrieveEventsParams(startDate: inicio, endDate: fim),
        );
        if (!eventos.isSuccess) throw Exception();
        compromissos.addAll(eventos.data!);
      }

      // O Android pode trazer eventos de dia inteiro do dia seguinte ao período.
      compromissos.removeWhere(
        (e) =>
            !_dataHora(e.start!).isBefore(fim) ||
            _dataHora(e.end!).isBefore(inicio),
      );
      compromissos.sort(
        (a, b) => _dataHora(a.start!).compareTo(_dataHora(b.start!)),
      );

      _compromissos = compromissos;
      _calendarios = {for (final c in calendarios.data!) c.id: c.name};
      if (compromissos.isEmpty) {
        _mensagem = 'Nenhum compromisso nos próximos 7 dias.';
      }
    } catch (_) {
      _mensagem = 'Falha ao consultar os compromissos.';
    } finally {
      setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compromissos')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _carregando ? null : _consultar,
            child: const Text('Consultar compromissos'),
          ),
          if (_carregando) const CircularProgressIndicator(),
          Text(_mensagem),
          Expanded(
            child: ListView.builder(
              itemCount: _compromissos.length,
              itemBuilder: (context, index) {
                final e = _compromissos[index];
                final diaInteiro = e.allDay == true;

                return ListTile(
                  title: Text(e.title ?? ''),
                  subtitle: Text(
                    '${diaInteiro ? 'Dia inteiro\n' : ''}'
                    'Calendário: ${_calendarios[e.calendarId]}\n'
                    'Início: ${_formatar(e.start!, diaInteiro)}\n'
                    'Fim: ${_formatar(e.end!, diaInteiro)}\n'
                    'Local: ${e.location ?? ''}\n'
                    'Descrição: ${e.description ?? ''}',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
