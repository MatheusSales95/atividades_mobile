class Localizacao {
  const Localizacao({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.precisao,
    required this.instante,
  });

  factory Localizacao.fromMap(Map<String, Object?> mapa) {
    return Localizacao(
      id: mapa['id'] as int,
      latitude: (mapa['latitude'] as num).toDouble(),
      longitude: (mapa['longitude'] as num).toDouble(),
      precisao: (mapa['precisao'] as num).toDouble(),
      instante: DateTime.parse(mapa['instante'] as String),
    );
  }

  final int? id;
  final double latitude;
  final double longitude;
  final double precisao; // em metros
  final DateTime instante;

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'precisao': precisao,
      'instante': instante.toUtc().toIso8601String(),
    };
  }
}
