import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Clean Architecture dependency rules', () {
    test('domain is independent from Flutter and outer layers', () {
      _expectNoForbiddenImports(
        'lib/domain',
        const [
          'package:flutter',
          'package:flutter_riverpod',
          '/data/',
          '/presentation/',
          '/di/',
          '/core/',
        ],
      );
    });

    test('data does not depend on presentation or composition root', () {
      _expectNoForbiddenImports(
        'lib/data',
        const ['/presentation/', '/di/'],
      );
    });

    test('presentation does not import data implementations or plugins', () {
      _expectNoForbiddenImports(
        'lib/presentation',
        const [
          '/data/',
          'package:isar',
          'package:just_audio',
          'package:on_audio_query',
          'package:permission_handler',
          'package:share_plus',
          'package:url_launcher',
          "dart:io",
        ],
      );
    });

    test('core stays framework and outer-layer independent', () {
      _expectNoForbiddenImports(
        'lib/core',
        const [
          'package:flutter',
          '/data/',
          '/presentation/',
          '/di/',
        ],
      );
    });
  });
}

void _expectNoForbiddenImports(
  String directoryPath,
  List<String> forbidden,
) {
  final violations = <String>[];
  final directory = Directory(directoryPath);

  for (final entity in directory.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final lines = entity.readAsLinesSync();
    for (var index = 0; index < lines.length; index++) {
      final line = lines[index].trim().replaceAll('\\', '/');
      if (!line.startsWith('import ')) continue;
      for (final rule in forbidden) {
        if (line.contains(rule)) {
          violations.add('${entity.path}:${index + 1} imports $rule');
        }
      }
    }
  }

  expect(violations, isEmpty, reason: violations.join('\n'));
}
