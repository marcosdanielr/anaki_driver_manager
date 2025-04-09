import 'dart:ffi';
import 'package:ffi/ffi.dart';

import '../bindings/odbc_bindings.dart' as bindings;
import '../bindings/odbc_error.dart';
import '../connection/odbc_connection.dart';
import 'callback_handler.dart';

class OdbcExecutor {
  final OdbcConnection conn;

  OdbcExecutor(this.conn);

  Future<List<Map<String, dynamic>>> execute(String sql) async {
    headers = null;
    resultRows.clear();

    final sqlPtr = sql.toNativeUtf8();
    final ret = bindings.execute(conn.handle, sqlPtr, callbackPointer, nullptr);
    calloc.free(sqlPtr);

    if (ret != OdbcError.success) {
      throw Exception("Failed to execute SQL statement. Error code: $ret");
    }

    return resultRows;
  }
}
