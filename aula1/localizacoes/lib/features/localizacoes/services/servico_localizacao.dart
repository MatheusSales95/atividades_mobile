import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class ServicoLocalizacao {
  const ServicoLocalizacao();

  Future<bool> gpsHabilitado() => Geolocator.isLocationServiceEnabled();

  Future<LocationPermission> solicitarPermissao() async {
    final permissao = await Geolocator.checkPermission();
    if (permissao != LocationPermission.denied) return permissao;
    return Geolocator.requestPermission();
  }

  // No Android 13+, sem essa permissão a notificação da coleta não aparece.
  Future<void> solicitarPermissaoNotificacao() =>
      Permission.notification.request();

  // Enquanto o stream estiver sendo ouvido, o Android mantém um serviço em
  // primeiro plano com notificação visível.
  Stream<Position> posicoes() {
    return Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.high,
        intervalDuration: const Duration(seconds: 20),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: 'Coleta de localização',
          notificationText: 'A coleta de localização está ativa.',
          notificationIcon: AndroidResource(name: 'icone_localizacoes'),
        ),
      ),
    );
  }

  Future<bool> abrirConfiguracoes() => Geolocator.openAppSettings();
}
