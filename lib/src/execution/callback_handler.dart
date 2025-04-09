import 'dart:ffi';
import 'package:ffi/ffi.dart';

final List<Map<String, dynamic>> resultRows = [];
List<String>? headers;

void _onExecuteCallback(Pointer<Utf8> line, Pointer<Void> userData) {
  final csvLine = line.toDartString();
  final values = csvLine.split(',');

  if (headers == null) {
    headers = values;
  } else {
    final row = <String, dynamic>{};
    for (var i = 0; i < headers!.length && i < values.length; i++) {
      final val = int.tryParse(values[i]) ?? values[i];
      row[headers![i]] = val;
    }
    resultRows.add(row);
  }
}

final callbackPointer =
    Pointer.fromFunction<Void Function(Pointer<Utf8>, Pointer<Void>)>(
        _onExecuteCallback);
