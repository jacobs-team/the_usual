import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(Nutrition, () {
    group('isEmpty', () {
      test('is true when every value is unset', () {
        expect(const Nutrition().isEmpty, isTrue);
      });

      test('is false when any value is set', () {
        expect(const Nutrition(calories: 100).isEmpty, isFalse);
      });
    });

    group('summary', () {
      test('joins every set value with a separator', () {
        const nutrition = Nutrition(
          calories: 420,
          protein: 28,
          fat: 14,
          carbs: 60,
        );

        expect(nutrition.summary, equals('420 cal · 28P · 60C · 14F'));
      });

      test('drops unset values', () {
        const nutrition = Nutrition(calories: 420, carbs: 60);

        expect(nutrition.summary, equals('420 cal · 60C'));
      });

      test('shows an em dash when nothing is set', () {
        expect(const Nutrition().summary, equals('—'));
      });
    });

    group('operator +', () {
      test('sums values, counting an unset value as zero', () {
        const a = Nutrition(calories: 200, protein: 10);
        const b = Nutrition(calories: 300, fat: 5);

        final total = a + b;

        expect(total.calories, equals(500));
        expect(total.protein, equals(10));
        expect(total.fat, equals(5));
        expect(total.carbs, equals(0));
      });
    });

    group('operator *', () {
      test('scales set values and rounds, leaving unset values unset', () {
        const nutrition = Nutrition(calories: 201, protein: 11);

        final scaled = nutrition * 1.5;

        expect(scaled.calories, equals(302));
        expect(scaled.protein, equals(17));
        expect(scaled.fat, isNull);
        expect(scaled.carbs, isNull);
      });
    });

    group('migrateLegacyJson', () {
      test('nests legacy top-level calories under nutrition', () {
        final migrated = Nutrition.migrateLegacyJson(<String, dynamic>{
          'name': 'Eggs',
          'calories': 300,
        });

        expect(migrated['nutrition'], equals({'calories': 300}));
        expect(migrated['name'], equals('Eggs'));
      });

      test('passes through json that already nests nutrition', () {
        final json = <String, dynamic>{
          'name': 'Eggs',
          'nutrition': {'calories': 300},
        };

        expect(Nutrition.migrateLegacyJson(json), same(json));
      });

      test('passes through json with no calories', () {
        final json = <String, dynamic>{'name': 'Eggs'};

        expect(Nutrition.migrateLegacyJson(json), same(json));
      });
    });
  });
}
