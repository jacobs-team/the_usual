import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(MealPhoto, () {
    test('defaults mediaType to image/jpeg', () {
      final photo = MealPhoto(bytes: Uint8List.fromList([1, 2, 3]));
      expect(photo.mediaType, equals('image/jpeg'));
      expect(photo.bytes, hasLength(3));
    });

    test('keeps the supplied mediaType', () {
      final photo = MealPhoto(
        bytes: Uint8List.fromList([1]),
        mediaType: 'image/png',
      );
      expect(photo.mediaType, equals('image/png'));
    });
  });
}
