import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/preferences_repository.dart';
import '../../domain/repositories/preferences_repository.dart';

final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  return PreferencesRepositoryImpl();
});
