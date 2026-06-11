import 'package:flutter_template/app/core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const key = 'key';
  const value = 'value';

  group('mapJson', () {
    test('returns correct object when $Map is valid', () {
      final raw = {key: value};
      final result = mapJson(raw, (json) => json[key] as String);
      expect(result, value);
    });

    test('throws $MappingException when $Map cast fails', () {
      expect(
        () => mapJson(123, (json) => json),
        throwsA(isA<MappingException>()),
      );
    });
  });

  group('mapJsonList', () {
    test('returns correct $List when raw data is valid', () {
      final raw = [
        {key: value},
        {key: 'value2'},
      ];
      final result = mapJsonList(raw, (json) => json[key] as String);
      expect(result, [value, 'value2']);
    });

    test('throws $MappingException when $List cast fails', () {
      expect(
        () => mapJsonList({key: value}, (json) => json),
        throwsA(isA<MappingException>()),
      );
    });
  });
}
