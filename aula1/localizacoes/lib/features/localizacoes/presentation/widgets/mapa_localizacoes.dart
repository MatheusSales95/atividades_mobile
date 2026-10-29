import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:localizacoes/features/localizacoes/models/localizacao.dart';

class MapaLocalizacoes extends StatefulWidget {
  const MapaLocalizacoes({
    super.key,
    required this.localizacoes,
    required this.cache,
  });

  /// Da mais recente para a mais antiga.
  final List<Localizacao> localizacoes;
  final MapCachingProvider cache;

  @override
  State<MapaLocalizacoes> createState() => _MapaLocalizacoesState();
}

class _MapaLocalizacoesState extends State<MapaLocalizacoes> {
  final _controlador = MapController();

  late final _pontos = [
    for (final l in widget.localizacoes) LatLng(l.latitude, l.longitude),
  ];

  late final _enquadramento = CameraFit.coordinates(
    coordinates: _pontos,
    padding: const EdgeInsets.all(48),
    maxZoom: 17,
  );

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _controlador,
      options: MapOptions(initialCameraFit: _enquadramento),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'io.github.matheussales95.localizacoes',
          tileProvider: NetworkTileProvider(cachingProvider: widget.cache),
        ),
        MarkerLayer(
          markers: [
            // A mais recente (índice 0) é desenhada por último, em vermelho.
            for (var i = _pontos.length - 1; i >= 0; i--)
              Marker(
                point: _pontos[i],
                alignment: Alignment.topCenter,
                child: Icon(
                  Icons.location_on,
                  color: i == 0 ? Colors.red : Colors.blue,
                ),
              ),
          ],
        ),
        const SimpleAttributionWidget(
          source: Text('OpenStreetMap contributors'),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: FloatingActionButton.small(
              tooltip: 'Enquadrar pontos',
              onPressed: () => _controlador.fitCamera(_enquadramento),
              child: const Icon(Icons.fit_screen),
            ),
          ),
        ),
      ],
    );
  }
}
