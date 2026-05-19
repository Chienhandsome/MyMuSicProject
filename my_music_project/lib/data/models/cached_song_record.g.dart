// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_song_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCachedSongRecordCollection on Isar {
  IsarCollection<CachedSongRecord> get cachedSongRecords => this.collection();
}

const CachedSongRecordSchema = CollectionSchema(
  name: r'CachedSongRecord',
  id: 3220414392612964352,
  properties: {
    r'artist': PropertySchema(
      id: 0,
      name: r'artist',
      type: IsarType.string,
    ),
    r'dateAddedMs': PropertySchema(
      id: 1,
      name: r'dateAddedMs',
      type: IsarType.long,
    ),
    r'dateModifiedMs': PropertySchema(
      id: 2,
      name: r'dateModifiedMs',
      type: IsarType.long,
    ),
    r'duration': PropertySchema(
      id: 3,
      name: r'duration',
      type: IsarType.long,
    ),
    r'extension': PropertySchema(
      id: 4,
      name: r'extension',
      type: IsarType.string,
    ),
    r'isFavorite': PropertySchema(
      id: 5,
      name: r'isFavorite',
      type: IsarType.bool,
    ),
    r'lastPlay': PropertySchema(
      id: 6,
      name: r'lastPlay',
      type: IsarType.long,
    ),
    r'lyric': PropertySchema(
      id: 7,
      name: r'lyric',
      type: IsarType.string,
    ),
    r'numberOfTimesPlayed': PropertySchema(
      id: 8,
      name: r'numberOfTimesPlayed',
      type: IsarType.long,
    ),
    r'path': PropertySchema(
      id: 9,
      name: r'path',
      type: IsarType.string,
    ),
    r'schemaVersion': PropertySchema(
      id: 10,
      name: r'schemaVersion',
      type: IsarType.long,
    ),
    r'size': PropertySchema(
      id: 11,
      name: r'size',
      type: IsarType.long,
    ),
    r'sourceId': PropertySchema(
      id: 12,
      name: r'sourceId',
      type: IsarType.long,
    ),
    r'title': PropertySchema(
      id: 13,
      name: r'title',
      type: IsarType.string,
    ),
    r'uri': PropertySchema(
      id: 14,
      name: r'uri',
      type: IsarType.string,
    )
  },
  estimateSize: _cachedSongRecordEstimateSize,
  serialize: _cachedSongRecordSerialize,
  deserialize: _cachedSongRecordDeserialize,
  deserializeProp: _cachedSongRecordDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'path': IndexSchema(
      id: 8756705481922369689,
      name: r'path',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'path',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _cachedSongRecordGetId,
  getLinks: _cachedSongRecordGetLinks,
  attach: _cachedSongRecordAttach,
  version: '3.1.0+1',
);

int _cachedSongRecordEstimateSize(
  CachedSongRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.artist;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.extension;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lyric;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.path.length * 3;
  bytesCount += 3 + object.title.length * 3;
  {
    final value = object.uri;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _cachedSongRecordSerialize(
  CachedSongRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.artist);
  writer.writeLong(offsets[1], object.dateAddedMs);
  writer.writeLong(offsets[2], object.dateModifiedMs);
  writer.writeLong(offsets[3], object.duration);
  writer.writeString(offsets[4], object.extension);
  writer.writeBool(offsets[5], object.isFavorite);
  writer.writeLong(offsets[6], object.lastPlay);
  writer.writeString(offsets[7], object.lyric);
  writer.writeLong(offsets[8], object.numberOfTimesPlayed);
  writer.writeString(offsets[9], object.path);
  writer.writeLong(offsets[10], object.schemaVersion);
  writer.writeLong(offsets[11], object.size);
  writer.writeLong(offsets[12], object.sourceId);
  writer.writeString(offsets[13], object.title);
  writer.writeString(offsets[14], object.uri);
}

CachedSongRecord _cachedSongRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CachedSongRecord();
  object.artist = reader.readStringOrNull(offsets[0]);
  object.dateAddedMs = reader.readLongOrNull(offsets[1]);
  object.dateModifiedMs = reader.readLongOrNull(offsets[2]);
  object.duration = reader.readLong(offsets[3]);
  object.extension = reader.readStringOrNull(offsets[4]);
  object.isFavorite = reader.readBool(offsets[5]);
  object.isarId = id;
  object.lastPlay = reader.readLongOrNull(offsets[6]);
  object.lyric = reader.readStringOrNull(offsets[7]);
  object.numberOfTimesPlayed = reader.readLongOrNull(offsets[8]);
  object.path = reader.readString(offsets[9]);
  object.schemaVersion = reader.readLong(offsets[10]);
  object.size = reader.readLongOrNull(offsets[11]);
  object.sourceId = reader.readLong(offsets[12]);
  object.title = reader.readString(offsets[13]);
  object.uri = reader.readStringOrNull(offsets[14]);
  return object;
}

P _cachedSongRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cachedSongRecordGetId(CachedSongRecord object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _cachedSongRecordGetLinks(CachedSongRecord object) {
  return [];
}

void _cachedSongRecordAttach(
    IsarCollection<dynamic> col, Id id, CachedSongRecord object) {
  object.isarId = id;
}

extension CachedSongRecordByIndex on IsarCollection<CachedSongRecord> {
  Future<CachedSongRecord?> getByPath(String path) {
    return getByIndex(r'path', [path]);
  }

  CachedSongRecord? getByPathSync(String path) {
    return getByIndexSync(r'path', [path]);
  }

  Future<bool> deleteByPath(String path) {
    return deleteByIndex(r'path', [path]);
  }

  bool deleteByPathSync(String path) {
    return deleteByIndexSync(r'path', [path]);
  }

  Future<List<CachedSongRecord?>> getAllByPath(List<String> pathValues) {
    final values = pathValues.map((e) => [e]).toList();
    return getAllByIndex(r'path', values);
  }

  List<CachedSongRecord?> getAllByPathSync(List<String> pathValues) {
    final values = pathValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'path', values);
  }

  Future<int> deleteAllByPath(List<String> pathValues) {
    final values = pathValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'path', values);
  }

  int deleteAllByPathSync(List<String> pathValues) {
    final values = pathValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'path', values);
  }

  Future<Id> putByPath(CachedSongRecord object) {
    return putByIndex(r'path', object);
  }

  Id putByPathSync(CachedSongRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'path', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPath(List<CachedSongRecord> objects) {
    return putAllByIndex(r'path', objects);
  }

  List<Id> putAllByPathSync(List<CachedSongRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'path', objects, saveLinks: saveLinks);
  }
}

extension CachedSongRecordQueryWhereSort
    on QueryBuilder<CachedSongRecord, CachedSongRecord, QWhere> {
  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CachedSongRecordQueryWhere
    on QueryBuilder<CachedSongRecord, CachedSongRecord, QWhereClause> {
  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterWhereClause>
      pathEqualTo(String path) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'path',
        value: [path],
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterWhereClause>
      pathNotEqualTo(String path) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'path',
              lower: [],
              upper: [path],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'path',
              lower: [path],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'path',
              lower: [path],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'path',
              lower: [],
              upper: [path],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CachedSongRecordQueryFilter
    on QueryBuilder<CachedSongRecord, CachedSongRecord, QFilterCondition> {
  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      artistIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'artist',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      artistIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'artist',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      artistEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'artist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      artistGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'artist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      artistLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'artist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      artistBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'artist',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      artistStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'artist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      artistEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'artist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      artistContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'artist',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      artistMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'artist',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      artistIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'artist',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      artistIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'artist',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      dateAddedMsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateAddedMs',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      dateAddedMsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateAddedMs',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      dateAddedMsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateAddedMs',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      dateAddedMsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateAddedMs',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      dateAddedMsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateAddedMs',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      dateAddedMsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateAddedMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      dateModifiedMsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dateModifiedMs',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      dateModifiedMsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dateModifiedMs',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      dateModifiedMsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateModifiedMs',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      dateModifiedMsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateModifiedMs',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      dateModifiedMsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateModifiedMs',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      dateModifiedMsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateModifiedMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      durationEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      durationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      durationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      durationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'duration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      extensionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'extension',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      extensionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'extension',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      extensionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'extension',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      extensionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'extension',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      extensionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'extension',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      extensionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'extension',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      extensionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'extension',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      extensionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'extension',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      extensionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'extension',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      extensionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'extension',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      extensionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'extension',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      extensionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'extension',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      isFavoriteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFavorite',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      lastPlayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastPlay',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      lastPlayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastPlay',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      lastPlayEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastPlay',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      lastPlayGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastPlay',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      lastPlayLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastPlay',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      lastPlayBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastPlay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      lyricIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lyric',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      lyricIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lyric',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      lyricEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lyric',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      lyricGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lyric',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      lyricLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lyric',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      lyricBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lyric',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      lyricStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lyric',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      lyricEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lyric',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      lyricContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lyric',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      lyricMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lyric',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      lyricIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lyric',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      lyricIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lyric',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      numberOfTimesPlayedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'numberOfTimesPlayed',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      numberOfTimesPlayedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'numberOfTimesPlayed',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      numberOfTimesPlayedEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numberOfTimesPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      numberOfTimesPlayedGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'numberOfTimesPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      numberOfTimesPlayedLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'numberOfTimesPlayed',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      numberOfTimesPlayedBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'numberOfTimesPlayed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      pathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      pathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      pathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      pathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'path',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      pathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      pathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      pathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'path',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      pathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'path',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      pathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'path',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      pathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'path',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      schemaVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'schemaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      schemaVersionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'schemaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      schemaVersionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'schemaVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      schemaVersionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'schemaVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      sizeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'size',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      sizeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'size',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      sizeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'size',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      sizeGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'size',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      sizeLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'size',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      sizeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'size',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      sourceIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceId',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      sourceIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceId',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      sourceIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceId',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      sourceIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      uriIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'uri',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      uriIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'uri',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      uriEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      uriGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      uriLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      uriBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uri',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      uriStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      uriEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      uriContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      uriMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uri',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      uriIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uri',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterFilterCondition>
      uriIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uri',
        value: '',
      ));
    });
  }
}

extension CachedSongRecordQueryObject
    on QueryBuilder<CachedSongRecord, CachedSongRecord, QFilterCondition> {}

extension CachedSongRecordQueryLinks
    on QueryBuilder<CachedSongRecord, CachedSongRecord, QFilterCondition> {}

extension CachedSongRecordQuerySortBy
    on QueryBuilder<CachedSongRecord, CachedSongRecord, QSortBy> {
  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortByArtist() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artist', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortByArtistDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artist', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortByDateAddedMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAddedMs', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortByDateAddedMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAddedMs', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortByDateModifiedMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateModifiedMs', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortByDateModifiedMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateModifiedMs', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortByExtension() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extension', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortByExtensionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extension', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortByLastPlay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlay', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortByLastPlayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlay', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy> sortByLyric() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lyric', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortByLyricDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lyric', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortByNumberOfTimesPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfTimesPlayed', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortByNumberOfTimesPlayedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfTimesPlayed', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy> sortByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortBySchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortBySchemaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy> sortBySize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'size', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortBySizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'size', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy> sortByUri() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uri', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      sortByUriDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uri', Sort.desc);
    });
  }
}

extension CachedSongRecordQuerySortThenBy
    on QueryBuilder<CachedSongRecord, CachedSongRecord, QSortThenBy> {
  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenByArtist() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artist', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenByArtistDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'artist', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenByDateAddedMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAddedMs', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenByDateAddedMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateAddedMs', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenByDateModifiedMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateModifiedMs', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenByDateModifiedMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateModifiedMs', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenByExtension() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extension', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenByExtensionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'extension', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenByLastPlay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlay', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenByLastPlayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPlay', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy> thenByLyric() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lyric', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenByLyricDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lyric', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenByNumberOfTimesPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfTimesPlayed', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenByNumberOfTimesPlayedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfTimesPlayed', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy> thenByPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenByPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'path', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenBySchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenBySchemaVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schemaVersion', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy> thenBySize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'size', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenBySizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'size', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy> thenByUri() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uri', Sort.asc);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QAfterSortBy>
      thenByUriDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uri', Sort.desc);
    });
  }
}

extension CachedSongRecordQueryWhereDistinct
    on QueryBuilder<CachedSongRecord, CachedSongRecord, QDistinct> {
  QueryBuilder<CachedSongRecord, CachedSongRecord, QDistinct> distinctByArtist(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'artist', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QDistinct>
      distinctByDateAddedMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateAddedMs');
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QDistinct>
      distinctByDateModifiedMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateModifiedMs');
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QDistinct>
      distinctByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'duration');
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QDistinct>
      distinctByExtension({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'extension', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QDistinct>
      distinctByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFavorite');
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QDistinct>
      distinctByLastPlay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastPlay');
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QDistinct> distinctByLyric(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lyric', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QDistinct>
      distinctByNumberOfTimesPlayed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'numberOfTimesPlayed');
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QDistinct> distinctByPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'path', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QDistinct>
      distinctBySchemaVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'schemaVersion');
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QDistinct> distinctBySize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'size');
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QDistinct>
      distinctBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceId');
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedSongRecord, CachedSongRecord, QDistinct> distinctByUri(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uri', caseSensitive: caseSensitive);
    });
  }
}

extension CachedSongRecordQueryProperty
    on QueryBuilder<CachedSongRecord, CachedSongRecord, QQueryProperty> {
  QueryBuilder<CachedSongRecord, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<CachedSongRecord, String?, QQueryOperations> artistProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'artist');
    });
  }

  QueryBuilder<CachedSongRecord, int?, QQueryOperations> dateAddedMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateAddedMs');
    });
  }

  QueryBuilder<CachedSongRecord, int?, QQueryOperations>
      dateModifiedMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateModifiedMs');
    });
  }

  QueryBuilder<CachedSongRecord, int, QQueryOperations> durationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'duration');
    });
  }

  QueryBuilder<CachedSongRecord, String?, QQueryOperations>
      extensionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'extension');
    });
  }

  QueryBuilder<CachedSongRecord, bool, QQueryOperations> isFavoriteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFavorite');
    });
  }

  QueryBuilder<CachedSongRecord, int?, QQueryOperations> lastPlayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastPlay');
    });
  }

  QueryBuilder<CachedSongRecord, String?, QQueryOperations> lyricProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lyric');
    });
  }

  QueryBuilder<CachedSongRecord, int?, QQueryOperations>
      numberOfTimesPlayedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'numberOfTimesPlayed');
    });
  }

  QueryBuilder<CachedSongRecord, String, QQueryOperations> pathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'path');
    });
  }

  QueryBuilder<CachedSongRecord, int, QQueryOperations>
      schemaVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'schemaVersion');
    });
  }

  QueryBuilder<CachedSongRecord, int?, QQueryOperations> sizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'size');
    });
  }

  QueryBuilder<CachedSongRecord, int, QQueryOperations> sourceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceId');
    });
  }

  QueryBuilder<CachedSongRecord, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<CachedSongRecord, String?, QQueryOperations> uriProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uri');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSongCacheMetadataRecordCollection on Isar {
  IsarCollection<SongCacheMetadataRecord> get songCacheMetadataRecords =>
      this.collection();
}

const SongCacheMetadataRecordSchema = CollectionSchema(
  name: r'SongCacheMetadataRecord',
  id: -2261502158176526883,
  properties: {
    r'key': PropertySchema(
      id: 0,
      name: r'key',
      type: IsarType.string,
    ),
    r'value': PropertySchema(
      id: 1,
      name: r'value',
      type: IsarType.long,
    )
  },
  estimateSize: _songCacheMetadataRecordEstimateSize,
  serialize: _songCacheMetadataRecordSerialize,
  deserialize: _songCacheMetadataRecordDeserialize,
  deserializeProp: _songCacheMetadataRecordDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'key': IndexSchema(
      id: -4906094122524121629,
      name: r'key',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'key',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _songCacheMetadataRecordGetId,
  getLinks: _songCacheMetadataRecordGetLinks,
  attach: _songCacheMetadataRecordAttach,
  version: '3.1.0+1',
);

int _songCacheMetadataRecordEstimateSize(
  SongCacheMetadataRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.key.length * 3;
  return bytesCount;
}

void _songCacheMetadataRecordSerialize(
  SongCacheMetadataRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.key);
  writer.writeLong(offsets[1], object.value);
}

SongCacheMetadataRecord _songCacheMetadataRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SongCacheMetadataRecord();
  object.isarId = id;
  object.key = reader.readString(offsets[0]);
  object.value = reader.readLong(offsets[1]);
  return object;
}

P _songCacheMetadataRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _songCacheMetadataRecordGetId(SongCacheMetadataRecord object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _songCacheMetadataRecordGetLinks(
    SongCacheMetadataRecord object) {
  return [];
}

void _songCacheMetadataRecordAttach(
    IsarCollection<dynamic> col, Id id, SongCacheMetadataRecord object) {
  object.isarId = id;
}

extension SongCacheMetadataRecordByIndex
    on IsarCollection<SongCacheMetadataRecord> {
  Future<SongCacheMetadataRecord?> getByKey(String key) {
    return getByIndex(r'key', [key]);
  }

  SongCacheMetadataRecord? getByKeySync(String key) {
    return getByIndexSync(r'key', [key]);
  }

  Future<bool> deleteByKey(String key) {
    return deleteByIndex(r'key', [key]);
  }

  bool deleteByKeySync(String key) {
    return deleteByIndexSync(r'key', [key]);
  }

  Future<List<SongCacheMetadataRecord?>> getAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndex(r'key', values);
  }

  List<SongCacheMetadataRecord?> getAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'key', values);
  }

  Future<int> deleteAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'key', values);
  }

  int deleteAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'key', values);
  }

  Future<Id> putByKey(SongCacheMetadataRecord object) {
    return putByIndex(r'key', object);
  }

  Id putByKeySync(SongCacheMetadataRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'key', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKey(List<SongCacheMetadataRecord> objects) {
    return putAllByIndex(r'key', objects);
  }

  List<Id> putAllByKeySync(List<SongCacheMetadataRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'key', objects, saveLinks: saveLinks);
  }
}

extension SongCacheMetadataRecordQueryWhereSort
    on QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord, QWhere> {
  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SongCacheMetadataRecordQueryWhere on QueryBuilder<
    SongCacheMetadataRecord, SongCacheMetadataRecord, QWhereClause> {
  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterWhereClause> isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterWhereClause> keyEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'key',
        value: [key],
      ));
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterWhereClause> keyNotEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [],
              upper: [key],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [key],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [key],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [],
              upper: [key],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SongCacheMetadataRecordQueryFilter on QueryBuilder<
    SongCacheMetadataRecord, SongCacheMetadataRecord, QFilterCondition> {
  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterFilterCondition> isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterFilterCondition> keyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterFilterCondition> keyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterFilterCondition> keyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterFilterCondition> keyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'key',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterFilterCondition> keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterFilterCondition> keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
          QAfterFilterCondition>
      keyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
          QAfterFilterCondition>
      keyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'key',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterFilterCondition> keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterFilterCondition> keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterFilterCondition> valueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
      ));
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterFilterCondition> valueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
      ));
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterFilterCondition> valueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
      ));
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord,
      QAfterFilterCondition> valueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SongCacheMetadataRecordQueryObject on QueryBuilder<
    SongCacheMetadataRecord, SongCacheMetadataRecord, QFilterCondition> {}

extension SongCacheMetadataRecordQueryLinks on QueryBuilder<
    SongCacheMetadataRecord, SongCacheMetadataRecord, QFilterCondition> {}

extension SongCacheMetadataRecordQuerySortBy
    on QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord, QSortBy> {
  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord, QAfterSortBy>
      sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord, QAfterSortBy>
      sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord, QAfterSortBy>
      sortByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord, QAfterSortBy>
      sortByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension SongCacheMetadataRecordQuerySortThenBy on QueryBuilder<
    SongCacheMetadataRecord, SongCacheMetadataRecord, QSortThenBy> {
  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord, QAfterSortBy>
      thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord, QAfterSortBy>
      thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord, QAfterSortBy>
      thenByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.asc);
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord, QAfterSortBy>
      thenByValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'value', Sort.desc);
    });
  }
}

extension SongCacheMetadataRecordQueryWhereDistinct on QueryBuilder<
    SongCacheMetadataRecord, SongCacheMetadataRecord, QDistinct> {
  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord, QDistinct>
      distinctByKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SongCacheMetadataRecord, SongCacheMetadataRecord, QDistinct>
      distinctByValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'value');
    });
  }
}

extension SongCacheMetadataRecordQueryProperty on QueryBuilder<
    SongCacheMetadataRecord, SongCacheMetadataRecord, QQueryProperty> {
  QueryBuilder<SongCacheMetadataRecord, int, QQueryOperations>
      isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<SongCacheMetadataRecord, String, QQueryOperations>
      keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<SongCacheMetadataRecord, int, QQueryOperations> valueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'value');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppSettingRecordCollection on Isar {
  IsarCollection<AppSettingRecord> get appSettingRecords => this.collection();
}

const AppSettingRecordSchema = CollectionSchema(
  name: r'AppSettingRecord',
  id: -6897423751675572856,
  properties: {
    r'boolValue': PropertySchema(
      id: 0,
      name: r'boolValue',
      type: IsarType.bool,
    ),
    r'intValue': PropertySchema(
      id: 1,
      name: r'intValue',
      type: IsarType.long,
    ),
    r'key': PropertySchema(
      id: 2,
      name: r'key',
      type: IsarType.string,
    ),
    r'stringValue': PropertySchema(
      id: 3,
      name: r'stringValue',
      type: IsarType.string,
    )
  },
  estimateSize: _appSettingRecordEstimateSize,
  serialize: _appSettingRecordSerialize,
  deserialize: _appSettingRecordDeserialize,
  deserializeProp: _appSettingRecordDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'key': IndexSchema(
      id: -4906094122524121629,
      name: r'key',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'key',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _appSettingRecordGetId,
  getLinks: _appSettingRecordGetLinks,
  attach: _appSettingRecordAttach,
  version: '3.1.0+1',
);

int _appSettingRecordEstimateSize(
  AppSettingRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.key.length * 3;
  {
    final value = object.stringValue;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _appSettingRecordSerialize(
  AppSettingRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.boolValue);
  writer.writeLong(offsets[1], object.intValue);
  writer.writeString(offsets[2], object.key);
  writer.writeString(offsets[3], object.stringValue);
}

AppSettingRecord _appSettingRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppSettingRecord();
  object.boolValue = reader.readBoolOrNull(offsets[0]);
  object.intValue = reader.readLongOrNull(offsets[1]);
  object.isarId = id;
  object.key = reader.readString(offsets[2]);
  object.stringValue = reader.readStringOrNull(offsets[3]);
  return object;
}

P _appSettingRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appSettingRecordGetId(AppSettingRecord object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _appSettingRecordGetLinks(AppSettingRecord object) {
  return [];
}

void _appSettingRecordAttach(
    IsarCollection<dynamic> col, Id id, AppSettingRecord object) {
  object.isarId = id;
}

extension AppSettingRecordByIndex on IsarCollection<AppSettingRecord> {
  Future<AppSettingRecord?> getByKey(String key) {
    return getByIndex(r'key', [key]);
  }

  AppSettingRecord? getByKeySync(String key) {
    return getByIndexSync(r'key', [key]);
  }

  Future<bool> deleteByKey(String key) {
    return deleteByIndex(r'key', [key]);
  }

  bool deleteByKeySync(String key) {
    return deleteByIndexSync(r'key', [key]);
  }

  Future<List<AppSettingRecord?>> getAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndex(r'key', values);
  }

  List<AppSettingRecord?> getAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'key', values);
  }

  Future<int> deleteAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'key', values);
  }

  int deleteAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'key', values);
  }

  Future<Id> putByKey(AppSettingRecord object) {
    return putByIndex(r'key', object);
  }

  Id putByKeySync(AppSettingRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'key', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKey(List<AppSettingRecord> objects) {
    return putAllByIndex(r'key', objects);
  }

  List<Id> putAllByKeySync(List<AppSettingRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'key', objects, saveLinks: saveLinks);
  }
}

extension AppSettingRecordQueryWhereSort
    on QueryBuilder<AppSettingRecord, AppSettingRecord, QWhere> {
  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppSettingRecordQueryWhere
    on QueryBuilder<AppSettingRecord, AppSettingRecord, QWhereClause> {
  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterWhereClause>
      isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterWhereClause>
      keyEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'key',
        value: [key],
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterWhereClause>
      keyNotEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [],
              upper: [key],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [key],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [key],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [],
              upper: [key],
              includeUpper: false,
            ));
      }
    });
  }
}

extension AppSettingRecordQueryFilter
    on QueryBuilder<AppSettingRecord, AppSettingRecord, QFilterCondition> {
  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      boolValueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'boolValue',
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      boolValueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'boolValue',
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      boolValueEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'boolValue',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      intValueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'intValue',
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      intValueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'intValue',
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      intValueEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intValue',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      intValueGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intValue',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      intValueLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intValue',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      intValueBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      keyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      keyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      keyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      keyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'key',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      keyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      keyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'key',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      stringValueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stringValue',
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      stringValueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stringValue',
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      stringValueEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stringValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      stringValueGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stringValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      stringValueLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stringValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      stringValueBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stringValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      stringValueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'stringValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      stringValueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'stringValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      stringValueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'stringValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      stringValueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'stringValue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      stringValueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stringValue',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterFilterCondition>
      stringValueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'stringValue',
        value: '',
      ));
    });
  }
}

extension AppSettingRecordQueryObject
    on QueryBuilder<AppSettingRecord, AppSettingRecord, QFilterCondition> {}

extension AppSettingRecordQueryLinks
    on QueryBuilder<AppSettingRecord, AppSettingRecord, QFilterCondition> {}

extension AppSettingRecordQuerySortBy
    on QueryBuilder<AppSettingRecord, AppSettingRecord, QSortBy> {
  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterSortBy>
      sortByBoolValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boolValue', Sort.asc);
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterSortBy>
      sortByBoolValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boolValue', Sort.desc);
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterSortBy>
      sortByIntValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intValue', Sort.asc);
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterSortBy>
      sortByIntValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intValue', Sort.desc);
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterSortBy>
      sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterSortBy>
      sortByStringValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stringValue', Sort.asc);
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterSortBy>
      sortByStringValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stringValue', Sort.desc);
    });
  }
}

extension AppSettingRecordQuerySortThenBy
    on QueryBuilder<AppSettingRecord, AppSettingRecord, QSortThenBy> {
  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterSortBy>
      thenByBoolValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boolValue', Sort.asc);
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterSortBy>
      thenByBoolValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'boolValue', Sort.desc);
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterSortBy>
      thenByIntValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intValue', Sort.asc);
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterSortBy>
      thenByIntValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intValue', Sort.desc);
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterSortBy>
      thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterSortBy>
      thenByStringValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stringValue', Sort.asc);
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QAfterSortBy>
      thenByStringValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stringValue', Sort.desc);
    });
  }
}

extension AppSettingRecordQueryWhereDistinct
    on QueryBuilder<AppSettingRecord, AppSettingRecord, QDistinct> {
  QueryBuilder<AppSettingRecord, AppSettingRecord, QDistinct>
      distinctByBoolValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'boolValue');
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QDistinct>
      distinctByIntValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intValue');
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QDistinct> distinctByKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSettingRecord, AppSettingRecord, QDistinct>
      distinctByStringValue({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stringValue', caseSensitive: caseSensitive);
    });
  }
}

extension AppSettingRecordQueryProperty
    on QueryBuilder<AppSettingRecord, AppSettingRecord, QQueryProperty> {
  QueryBuilder<AppSettingRecord, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<AppSettingRecord, bool?, QQueryOperations> boolValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'boolValue');
    });
  }

  QueryBuilder<AppSettingRecord, int?, QQueryOperations> intValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intValue');
    });
  }

  QueryBuilder<AppSettingRecord, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<AppSettingRecord, String?, QQueryOperations>
      stringValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stringValue');
    });
  }
}
