import 'dart:ffi';
import 'package:ffi/ffi.dart';

final DynamicLibrary lib = DynamicLibrary.open("odbc.so");

@Packed(8)
final class BinaryData extends Struct {
  external Pointer<Uint8> data;
  @IntPtr()
  external int len;
}

typedef _CreateConnectionC = Pointer<Void> Function();
final createConnection =
    lib.lookupFunction<_CreateConnectionC, Pointer<Void> Function()>(
        'odbc_create_connection');

typedef _FreeConnectionC = Int32 Function(Pointer<Void>);
final freeConnection =
    lib.lookupFunction<_FreeConnectionC, int Function(Pointer<Void>)>(
        'odbc_free_connection');

typedef _ConnectC = Int32 Function(Pointer<Void>, Pointer<Utf8>);
final connect =
    lib.lookupFunction<_ConnectC, int Function(Pointer<Void>, Pointer<Utf8>)>(
        'odbc_connect');

typedef _ExecuteCallback = Void Function(Pointer<BinaryData>, Pointer<Void>);
typedef _ExecuteC = Int32 Function(
  Pointer<Void>,
  Pointer<Utf8>,
  Pointer<NativeFunction<_ExecuteCallback>>,
  Pointer<Void>,
);
final execute = lib.lookupFunction<
    _ExecuteC,
    int Function(
      Pointer<Void>,
      Pointer<Utf8>,
      Pointer<NativeFunction<_ExecuteCallback>>,
      Pointer<Void>,
    )>('odbc_execute');
