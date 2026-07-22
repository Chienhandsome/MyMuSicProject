import '../../domain/gateways/app_initialization_gateway.dart';
import '../services/audio_player_service.dart';
import '../services/isar_storage_service.dart';

class AppInitializationGatewayImpl implements AppInitializationGateway {
  @override
  Future<void> initialize() async {
    await IsarStorageService.init();
    await initAudioPlayerHandler();
  }
}
