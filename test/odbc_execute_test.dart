import 'dart:io';

import 'package:anaki_driver_manager/anaki_driver_manager.dart';
import 'package:test/test.dart';

void main() {
  group('OdbcConnection.execute', () {
    test('should execute SQL and return data as Map<String, dynamic>',
        () async {
      final connStr = Platform.environment['TEST_DATABASE_URL'];

      final conn = OdbcConnection.connect(connStr!);
      expect(conn, isNotNull, reason: 'Connection should not be null');

      final executor = OdbcExecutor(conn!);

      final result = await executor.execute("SELECT 1 AS id, 'test' AS name");

      expect(result.length, equals(1), reason: 'Result should contain one row');
      expect(result[0], containsPair('id', 1), reason: 'ID should be 1');
      expect(result[0], containsPair('name', 'test'),
          reason: 'Name should be "test"');

      conn.close();
    });
  });
}
