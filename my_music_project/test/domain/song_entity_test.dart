import 'package:flutter_test/flutter_test.dart';
import 'package:my_music_project/domain/entities/song.dart';

void main() {
  group('Song entity', () {
    group('durationText', () {
      test('formats zero duration as 00:00', () {
        final song = _song(duration: 0);
        expect(song.durationText, '00:00');
      });

      test('formats seconds correctly', () {
        final song = _song(duration: 5000); // 5 seconds
        expect(song.durationText, '00:05');
      });

      test('formats minutes and seconds correctly', () {
        final song = _song(duration: 185000); // 3:05
        expect(song.durationText, '03:05');
      });

      test('formats exact minute', () {
        final song = _song(duration: 60000); // 1:00
        expect(song.durationText, '01:00');
      });

      test('formats long duration', () {
        final song = _song(duration: 3661000); // 61:01
        expect(song.durationText, '61:01');
      });

      test('pads single digit minutes and seconds', () {
        final song = _song(duration: 65000); // 1:05
        expect(song.durationText, '01:05');
      });
    });

    group('setTitle', () {
      test('updates the song title', () {
        final song = _song();
        song.setTitle('New Title');
        expect(song.title, 'New Title');
      });
    });

    group('playback stats', () {
      test('lastPlay defaults to null', () {
        final song = _song();
        expect(song.getLastPlay(), isNull);
      });

      test('setLastPlay updates the value', () {
        final song = _song();
        song.setLastPlay(1000);
        expect(song.getLastPlay(), 1000);
      });

      test('numberOfTimesPlayed defaults to null', () {
        final song = _song();
        expect(song.getNumberOfTimesPlayed(), isNull);
      });

      test('setNumberOfTimesPlayed updates the value', () {
        final song = _song();
        song.setNumberOfTimesPlayed(5);
        expect(song.getNumberOfTimesPlayed(), 5);
      });
    });

    group('isFavorite', () {
      test('defaults to false', () {
        final song = _song();
        expect(song.isFavorite, isFalse);
      });

      test('can be set to true', () {
        final song = _song();
        song.isFavorite = true;
        expect(song.isFavorite, isTrue);
      });
    });

    group('constructor', () {
      test('creates song with required fields only', () {
        final song = Song(id: 1, title: 'Test', path: '/test.mp3', duration: 1000);
        expect(song.id, 1);
        expect(song.title, 'Test');
        expect(song.path, '/test.mp3');
        expect(song.duration, 1000);
        expect(song.artist, isNull);
        expect(song.lyric, isNull);
        expect(song.uri, isNull);
        expect(song.size, isNull);
        expect(song.extension, isNull);
        expect(song.dateAddedMs, isNull);
        expect(song.dateModifiedMs, isNull);
      });

      test('creates song with all fields', () {
        final song = Song(
          id: 42,
          title: 'Full Song',
          path: '/music/full.mp3',
          duration: 240000,
          lyric: 'Some lyrics',
          artist: 'Artist Name',
          uri: 'content://media/42',
          size: 5000000,
          extension: 'mp3',
          dateAddedMs: 1700000000000,
          dateModifiedMs: 1700000001000,
          lastPlay: 1700000002000,
          numberOfTimesPlayed: 10,
          isFavorite: true,
        );

        expect(song.id, 42);
        expect(song.artist, 'Artist Name');
        expect(song.lyric, 'Some lyrics');
        expect(song.uri, 'content://media/42');
        expect(song.size, 5000000);
        expect(song.extension, 'mp3');
        expect(song.dateAddedMs, 1700000000000);
        expect(song.dateModifiedMs, 1700000001000);
        expect(song.lastPlay, 1700000002000);
        expect(song.numberOfTimesPlayed, 10);
        expect(song.isFavorite, isTrue);
      });
    });
  });
}

Song _song({int duration = 180000}) {
  return Song(id: 1, title: 'Test Song', path: '/test.mp3', duration: duration);
}
