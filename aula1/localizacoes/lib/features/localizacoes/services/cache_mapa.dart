import 'package:flutter_map/flutter_map.dart';
import 'package:path_provider/path_provider.dart';

class CacheMapa {
  // Guarda as imagens do mapa na pasta de cache privada do aplicativo. O cache
  // segue os cabeçalhos HTTP do servidor, como pede o OpenStreetMap.
  static Future<MapCachingProvider> preparar() async {
    final pasta = await getApplicationCacheDirectory();
    return BuiltInMapCachingProvider.getOrCreateInstance(
      cacheDirectory: '${pasta.path}/mapa',
    );
  }
}
