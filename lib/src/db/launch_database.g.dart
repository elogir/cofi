// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launch_database.dart';

// ignore_for_file: type=lint
class $AppLaunchesTable extends AppLaunches
    with TableInfo<$AppLaunchesTable, AppLaunch> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppLaunchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _launchCountMeta = const VerificationMeta(
    'launchCount',
  );
  @override
  late final GeneratedColumn<int> launchCount = GeneratedColumn<int>(
    'launch_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastLaunchedAtMeta = const VerificationMeta(
    'lastLaunchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastLaunchedAt =
      GeneratedColumn<DateTime>(
        'last_launched_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [id, launchCount, lastLaunchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_launches';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppLaunch> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('launch_count')) {
      context.handle(
        _launchCountMeta,
        launchCount.isAcceptableOrUnknown(
          data['launch_count']!,
          _launchCountMeta,
        ),
      );
    }
    if (data.containsKey('last_launched_at')) {
      context.handle(
        _lastLaunchedAtMeta,
        lastLaunchedAt.isAcceptableOrUnknown(
          data['last_launched_at']!,
          _lastLaunchedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppLaunch map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppLaunch(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      launchCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}launch_count'],
      )!,
      lastLaunchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_launched_at'],
      ),
    );
  }

  @override
  $AppLaunchesTable createAlias(String alias) {
    return $AppLaunchesTable(attachedDatabase, alias);
  }
}

class AppLaunch extends DataClass implements Insertable<AppLaunch> {
  final String id;
  final int launchCount;
  final DateTime? lastLaunchedAt;
  const AppLaunch({
    required this.id,
    required this.launchCount,
    this.lastLaunchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['launch_count'] = Variable<int>(launchCount);
    if (!nullToAbsent || lastLaunchedAt != null) {
      map['last_launched_at'] = Variable<DateTime>(lastLaunchedAt);
    }
    return map;
  }

  AppLaunchesCompanion toCompanion(bool nullToAbsent) {
    return AppLaunchesCompanion(
      id: Value(id),
      launchCount: Value(launchCount),
      lastLaunchedAt: lastLaunchedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLaunchedAt),
    );
  }

  factory AppLaunch.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppLaunch(
      id: serializer.fromJson<String>(json['id']),
      launchCount: serializer.fromJson<int>(json['launchCount']),
      lastLaunchedAt: serializer.fromJson<DateTime?>(json['lastLaunchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'launchCount': serializer.toJson<int>(launchCount),
      'lastLaunchedAt': serializer.toJson<DateTime?>(lastLaunchedAt),
    };
  }

  AppLaunch copyWith({
    String? id,
    int? launchCount,
    Value<DateTime?> lastLaunchedAt = const Value.absent(),
  }) => AppLaunch(
    id: id ?? this.id,
    launchCount: launchCount ?? this.launchCount,
    lastLaunchedAt: lastLaunchedAt.present
        ? lastLaunchedAt.value
        : this.lastLaunchedAt,
  );
  AppLaunch copyWithCompanion(AppLaunchesCompanion data) {
    return AppLaunch(
      id: data.id.present ? data.id.value : this.id,
      launchCount: data.launchCount.present
          ? data.launchCount.value
          : this.launchCount,
      lastLaunchedAt: data.lastLaunchedAt.present
          ? data.lastLaunchedAt.value
          : this.lastLaunchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppLaunch(')
          ..write('id: $id, ')
          ..write('launchCount: $launchCount, ')
          ..write('lastLaunchedAt: $lastLaunchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, launchCount, lastLaunchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppLaunch &&
          other.id == this.id &&
          other.launchCount == this.launchCount &&
          other.lastLaunchedAt == this.lastLaunchedAt);
}

class AppLaunchesCompanion extends UpdateCompanion<AppLaunch> {
  final Value<String> id;
  final Value<int> launchCount;
  final Value<DateTime?> lastLaunchedAt;
  final Value<int> rowid;
  const AppLaunchesCompanion({
    this.id = const Value.absent(),
    this.launchCount = const Value.absent(),
    this.lastLaunchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppLaunchesCompanion.insert({
    required String id,
    this.launchCount = const Value.absent(),
    this.lastLaunchedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<AppLaunch> custom({
    Expression<String>? id,
    Expression<int>? launchCount,
    Expression<DateTime>? lastLaunchedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (launchCount != null) 'launch_count': launchCount,
      if (lastLaunchedAt != null) 'last_launched_at': lastLaunchedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppLaunchesCompanion copyWith({
    Value<String>? id,
    Value<int>? launchCount,
    Value<DateTime?>? lastLaunchedAt,
    Value<int>? rowid,
  }) {
    return AppLaunchesCompanion(
      id: id ?? this.id,
      launchCount: launchCount ?? this.launchCount,
      lastLaunchedAt: lastLaunchedAt ?? this.lastLaunchedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (launchCount.present) {
      map['launch_count'] = Variable<int>(launchCount.value);
    }
    if (lastLaunchedAt.present) {
      map['last_launched_at'] = Variable<DateTime>(lastLaunchedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppLaunchesCompanion(')
          ..write('id: $id, ')
          ..write('launchCount: $launchCount, ')
          ..write('lastLaunchedAt: $lastLaunchedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LaunchDatabase extends GeneratedDatabase {
  _$LaunchDatabase(QueryExecutor e) : super(e);
  $LaunchDatabaseManager get managers => $LaunchDatabaseManager(this);
  late final $AppLaunchesTable appLaunches = $AppLaunchesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [appLaunches];
}

typedef $$AppLaunchesTableCreateCompanionBuilder =
    AppLaunchesCompanion Function({
      required String id,
      Value<int> launchCount,
      Value<DateTime?> lastLaunchedAt,
      Value<int> rowid,
    });
typedef $$AppLaunchesTableUpdateCompanionBuilder =
    AppLaunchesCompanion Function({
      Value<String> id,
      Value<int> launchCount,
      Value<DateTime?> lastLaunchedAt,
      Value<int> rowid,
    });

class $$AppLaunchesTableFilterComposer
    extends Composer<_$LaunchDatabase, $AppLaunchesTable> {
  $$AppLaunchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get launchCount => $composableBuilder(
    column: $table.launchCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastLaunchedAt => $composableBuilder(
    column: $table.lastLaunchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppLaunchesTableOrderingComposer
    extends Composer<_$LaunchDatabase, $AppLaunchesTable> {
  $$AppLaunchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get launchCount => $composableBuilder(
    column: $table.launchCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastLaunchedAt => $composableBuilder(
    column: $table.lastLaunchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppLaunchesTableAnnotationComposer
    extends Composer<_$LaunchDatabase, $AppLaunchesTable> {
  $$AppLaunchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get launchCount => $composableBuilder(
    column: $table.launchCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastLaunchedAt => $composableBuilder(
    column: $table.lastLaunchedAt,
    builder: (column) => column,
  );
}

class $$AppLaunchesTableTableManager
    extends
        RootTableManager<
          _$LaunchDatabase,
          $AppLaunchesTable,
          AppLaunch,
          $$AppLaunchesTableFilterComposer,
          $$AppLaunchesTableOrderingComposer,
          $$AppLaunchesTableAnnotationComposer,
          $$AppLaunchesTableCreateCompanionBuilder,
          $$AppLaunchesTableUpdateCompanionBuilder,
          (
            AppLaunch,
            BaseReferences<_$LaunchDatabase, $AppLaunchesTable, AppLaunch>,
          ),
          AppLaunch,
          PrefetchHooks Function()
        > {
  $$AppLaunchesTableTableManager(_$LaunchDatabase db, $AppLaunchesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppLaunchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppLaunchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppLaunchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> launchCount = const Value.absent(),
                Value<DateTime?> lastLaunchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppLaunchesCompanion(
                id: id,
                launchCount: launchCount,
                lastLaunchedAt: lastLaunchedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int> launchCount = const Value.absent(),
                Value<DateTime?> lastLaunchedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppLaunchesCompanion.insert(
                id: id,
                launchCount: launchCount,
                lastLaunchedAt: lastLaunchedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppLaunchesTableProcessedTableManager =
    ProcessedTableManager<
      _$LaunchDatabase,
      $AppLaunchesTable,
      AppLaunch,
      $$AppLaunchesTableFilterComposer,
      $$AppLaunchesTableOrderingComposer,
      $$AppLaunchesTableAnnotationComposer,
      $$AppLaunchesTableCreateCompanionBuilder,
      $$AppLaunchesTableUpdateCompanionBuilder,
      (
        AppLaunch,
        BaseReferences<_$LaunchDatabase, $AppLaunchesTable, AppLaunch>,
      ),
      AppLaunch,
      PrefetchHooks Function()
    >;

class $LaunchDatabaseManager {
  final _$LaunchDatabase _db;
  $LaunchDatabaseManager(this._db);
  $$AppLaunchesTableTableManager get appLaunches =>
      $$AppLaunchesTableTableManager(_db, _db.appLaunches);
}
