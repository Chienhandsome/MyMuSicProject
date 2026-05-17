import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/play_config_repository.dart';
import '../../domain/repositories/play_config_repository.dart';

final playConfigRepositoryProvider = Provider<PlayConfigRepository>((ref) {
  return PlayConfigRepositoryImpl();
});
