/// Database interface that works on all platforms
/// Implementations: AppDatabase (mobile) and WebDatabase (web)
abstract class DatabaseInterface {
  Future<void> initialize();
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
  });
  Future<int> insert(String table, Map<String, dynamic> values, {String? conflictAlgorithm});
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  });
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  });
  Future<void> execute(String sql, [List<Object?>? arguments]);
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<Object?>? arguments]);
  Future<void> close();
  Future<void> batchInsert(String table, List<Map<String, dynamic>> values, {String? conflictAlgorithm});
}

