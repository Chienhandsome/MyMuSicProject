import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/preferences_repository.dart';
import '../../data/services/app_settings_service.dart';
import '../../domain/repositories/preferences_repository.dart';

final appSettingsServiceProvider = Provider<AppSettingsService>((ref) {
  return AppSettingsService();
});

final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  return PreferencesRepositoryImpl(ref.watch(appSettingsServiceProvider));
});
