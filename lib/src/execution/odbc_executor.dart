import 'dart:ffi';
import 'package:ffi/ffi.dart';

import '../bindings/odbc_bindings.dart' as bindings;
import '../bindings/odbc_error.dart';
import '../connection/odbc_connection.dart';
import 'callback_handler.dart';

class QueryResult {
  final List<Map<String, dynamic>> rows;

  final int? affectedRows;

  QueryResult(this.rows, this.affectedRows);
}

class OdbcExecutor {
  final OdbcConnection conn;

  OdbcExecutor(this.conn);

  Future<QueryResult> execute(String sql) async {
    resultRows.clear();
    affectedRows = null;

    final sqlPtr = sql.toNativeUtf8();
    final ret = bindings.execute(conn.handle, sqlPtr, callbackPointer, nullptr);
    calloc.free(sqlPtr);

    if (ret != OdbcError.success) {
      throw Exception("Failed to execute SQL statement. Error code: $ret");
    }

    return QueryResult(resultRows, affectedRows);
  }

  int? getAffectedRows() {
    return affectedRows;
  }
}
