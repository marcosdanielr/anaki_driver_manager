import 'dart:ffi';
import 'package:ffi/ffi.dart';
import '../bindings/odbc_bindings.dart' as bindings;
import '../bindings/odbc_error.dart';

class OdbcConnection {
  final Pointer<Void> _handle;

  OdbcConnection._(this._handle);

  static OdbcConnection? connect(String connStr) {
    final handle = bindings.createConnection();
    if (handle == nullptr) {
      print("Failed to create connection.");
      return null;
    }

    final connStrPtr = connStr.toNativeUtf8();
    final result = bindings.connect(handle, connStrPtr);
    calloc.free(connStrPtr);

    if (result != OdbcError.success) {
      print("Failed to connect: error code $result");
      bindings.freeConnection(handle);
      return null;
    }

    return OdbcConnection._(handle);
  }

  Pointer<Void> get handle => _handle;

  void close() {
    bindings.freeConnection(_handle);
  }
}
