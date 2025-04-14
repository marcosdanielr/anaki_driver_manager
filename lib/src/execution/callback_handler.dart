import 'dart:ffi';
import 'dart:typed_data';
import 'package:msgpack_dart/msgpack_dart.dart' as msgpack;
import '../bindings/odbc_bindings.dart';

final List<Map<String, dynamic>> resultRows = [];
int? affectedRows;

void _onExecuteCallback(Pointer<BinaryData> data, Pointer<Void> userData) {
  final binaryData = data.cast<BinaryData>().ref;
  final pointer = binaryData.data;

  final bytes = Uint8List(binaryData.len);
  for (var i = 0; i < binaryData.len; i++) {
    bytes[i] = (pointer + i).value;
  }

  try {
    final decoded = msgpack.deserialize(bytes);
    print('Decoded data type: ${decoded.runtimeType}');
    print('Decoded data: $decoded');

    if (decoded is Map) {
      resultRows.add(Map<String, dynamic>.from(decoded));
      return;
    }

    if (decoded is List && decoded.isNotEmpty) {
      affectedRows = int.parse(decoded[0].toString());
    }
  } catch (e) {
    print('Error decoding MessagePack data: $e');
  }
}

final callbackPointer =
    Pointer.fromFunction<Void Function(Pointer<BinaryData>, Pointer<Void>)>(
        _onExecuteCallback);
