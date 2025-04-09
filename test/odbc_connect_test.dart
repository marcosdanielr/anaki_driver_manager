import 'dart:io';

import 'package:anaki_driver_manager/anaki_driver_manager.dart';
import 'package:test/test.dart';

void main() {
  group('OdbcConnection', () {
    test('connects and closes successfully', () {
      final connStr = Platform.environment['TEST_DATABASE_URL'];
      final conn = OdbcConnection.connect(connStr!);
      expect(conn, isNotNull, reason: 'Connection should not be null');

      conn?.close();
    });
  });
}
