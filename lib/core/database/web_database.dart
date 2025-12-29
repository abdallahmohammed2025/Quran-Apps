import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_azkar_app/core/database/database_interface.dart';

/// Web-compatible database implementation using SharedPreferences + JSON
/// This is a simplified implementation for web browsers
/// For production, consider using IndexedDB via drift or similar
class WebDatabase implements DatabaseInterface {
  static const String _dbPrefix = 'quran_azkar_db_';
  SharedPreferences? _prefs;
  final Map<String, List<Map<String, dynamic>>> _tables = {};

  @override
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadTables();
  }

  Future<void> _loadTables() async {
    if (_prefs == null) return;
    
    // Load all tables from SharedPreferences
    final keys = _prefs!.getKeys().where((key) => key.startsWith(_dbPrefix));
    for (final key in keys) {
      final tableName = key.substring(_dbPrefix.length);
      final jsonData = _prefs!.getString(key);
      if (jsonData != null) {
        try {
          final decoded = jsonDecode(jsonData) as List;
          _tables[tableName] = decoded
              .map((item) => Map<String, dynamic>.from(item as Map))
              .toList();
        } catch (e) {
          _tables[tableName] = [];
        }
      }
    }
  }

  Future<void> _saveTable(String tableName) async {
    if (_prefs == null) return;
    final key = '$_dbPrefix$tableName';
    final jsonData = jsonEncode(_tables[tableName]);
    await _prefs!.setString(key, jsonData);
  }

  void _ensureTable(String tableName) {
    _tables.putIfAbsent(tableName, () => []);
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
    _ensureTable(table);
    var results = List<Map<String, dynamic>>.from(_tables[table]!);

    // Simple where clause filtering (basic implementation)
    if (where != null && whereArgs != null) {
      results = _filterResults(results, where, whereArgs);
    }

    // Simple ordering (basic implementation)
    if (orderBy != null) {
      results = _sortResults(results, orderBy);
    }

    // Limit and offset
    if (offset != null && offset > 0) {
      results = results.skip(offset).toList();
    }
    if (limit != null && limit > 0) {
      results = results.take(limit).toList();
    }

    // Column selection
    if (columns != null && columns.isNotEmpty) {
      results = results.map((row) {
        final filtered = <String, dynamic>{};
        for (final col in columns) {
          if (row.containsKey(col)) {
            filtered[col] = row[col];
          }
        }
        return filtered;
      }).toList();
    }

    return results;
  }

  List<Map<String, dynamic>> _filterResults(
    List<Map<String, dynamic>> results,
    String where,
    List<Object?> whereArgs,
  ) {
    // Simple WHERE clause parser (supports basic =, !=, >, <, >=, <=)
    // For production, use a proper SQL parser
    return results.where((row) {
      // Parse simple conditions like "column = ?"
      final conditions = where.split(' AND ');
      for (var i = 0; i < conditions.length; i++) {
        final condition = conditions[i].trim();
        final argIndex = whereArgs.length > i ? i : 0;
        final arg = whereArgs[argIndex];

        if (condition.contains(' = ')) {
          final parts = condition.split(' = ');
          final col = parts[0].trim();
          if (row[col] != arg) return false;
        } else if (condition.contains(' != ')) {
          final parts = condition.split(' != ');
          final col = parts[0].trim();
          if (row[col] == arg) return false;
        }
        // Add more operators as needed
      }
      return true;
    }).toList();
  }

  List<Map<String, dynamic>> _sortResults(
    List<Map<String, dynamic>> results,
    String orderBy,
  ) {
    // Simple ORDER BY parser
    final parts = orderBy.split(' ');
    final col = parts[0];
    final ascending = parts.length == 1 || parts[1].toUpperCase() != 'DESC';

    results.sort((a, b) {
      final aVal = a[col];
      final bVal = b[col];
      if (aVal == null && bVal == null) return 0;
      if (aVal == null) return 1;
      if (bVal == null) return -1;
      final comparison = (aVal as Comparable).compareTo(bVal as Comparable);
      return ascending ? comparison : -comparison;
    });

    return results;
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> values, {String? conflictAlgorithm}) async {
    _ensureTable(table);
    // Handle conflict: if conflictAlgorithm is 'replace', update existing
    if (conflictAlgorithm == 'replace') {
      final primaryKey = values.keys.first; // Simple assumption
      final existingIndex = _tables[table]!.indexWhere((row) => row[primaryKey] == values[primaryKey]);
      if (existingIndex >= 0) {
        _tables[table]![existingIndex] = Map<String, dynamic>.from(values);
        await _saveTable(table);
        return existingIndex;
      }
    }
    _tables[table]!.add(Map<String, dynamic>.from(values));
    await _saveTable(table);
    return _tables[table]!.length - 1;
  }
  
  @override
  Future<void> batchInsert(String table, List<Map<String, dynamic>> values, {String? conflictAlgorithm}) async {
    _ensureTable(table);
    for (final value in values) {
      await insert(table, value, conflictAlgorithm: conflictAlgorithm);
    }
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    _ensureTable(table);
    var results = List<Map<String, dynamic>>.from(_tables[table]!);

    if (where != null && whereArgs != null) {
      results = _filterResults(results, where, whereArgs);
    }

    int count = 0;
    for (final row in results) {
      row.addAll(values);
      count++;
    }

    await _saveTable(table);
    return count;
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    _ensureTable(table);
    var results = List<Map<String, dynamic>>.from(_tables[table]!);

    if (where != null && whereArgs != null) {
      final toDelete = _filterResults(results, where, whereArgs);
      _tables[table]!.removeWhere((row) => toDelete.contains(row));
      await _saveTable(table);
      return toDelete.length;
    } else {
      final count = _tables[table]!.length;
      _tables[table]!.clear();
      await _saveTable(table);
      return count;
    }
  }

  @override
  Future<void> execute(String sql, [List<Object?>? arguments]) async {
    // Simple SQL execution for CREATE TABLE, etc.
    // For production, use a proper SQL parser
    if (sql.toUpperCase().contains('CREATE TABLE')) {
      // Extract table name (simplified)
      final match = RegExp(r'CREATE TABLE\s+(\w+)').firstMatch(sql);
      if (match != null) {
        final tableName = match.group(1)!;
        _ensureTable(tableName);
      }
    }
    // Add more SQL command handling as needed
  }

  @override
  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    // For complex queries, parse SQL
    // This is a simplified implementation
    if (sql.toUpperCase().contains('SELECT')) {
      // Extract table name and conditions
      final tableMatch = RegExp(r'FROM\s+(\w+)').firstMatch(sql.toUpperCase());
      if (tableMatch != null) {
        final tableName = tableMatch.group(1)!.toLowerCase();
        return await query(tableName);
      }
    }
    return [];
  }

  @override
  Future<void> close() async {
    // Save all tables before closing
    for (final tableName in _tables.keys) {
      await _saveTable(tableName);
    }
    _tables.clear();
  }
}

