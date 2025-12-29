import 'package:sqflite/sqflite.dart';
import 'package:quran_azkar_app/core/database/database_interface.dart';

/// Adapter to make SQLite Database compatible with DatabaseInterface
class MobileDatabaseAdapter implements DatabaseInterface {
  final Database _database;

  MobileDatabaseAdapter(this._database);

  @override
  Future<void> initialize() async {
    // Already initialized
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    return await _database.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> values) async {
    return await _database.insert(table, values);
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    return await _database.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
    );
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    return await _database.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }

  @override
  Future<void> execute(String sql, [List<Object?>? arguments]) async {
    await _database.execute(sql, arguments);
  }

  @override
  Future<List<Map<String, dynamic>>> rawQuery(
    String sql,
    [List<Object?>? arguments],
  ) async {
    return await _database.rawQuery(sql, arguments);
  }

  @override
  Future<void> close() async {
    await _database.close();
  }
}

