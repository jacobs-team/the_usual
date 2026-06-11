import 'package:dio/dio.dart';
import 'package:flutter_template/app/core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

void main() {
  const url = 'url';

  group(CoffeeRepository, () {
    late CoffeeApi coffeeApi;
    late CoffeeRepository coffeeRepository;

    setUp(() {
      initHydratedStorage();
      coffeeApi = MockCoffeeApi();
      coffeeRepository = CoffeeRepository(coffeeApi);
    });

    test(
      'getCoffeeImage returns $Coffee when api call is successful',
      () async {
        final data = {'file': url};
        when(() => coffeeApi.getCoffeeImageUrl()).thenAnswer(
          (_) async => Response(
            data: data,
            requestOptions: RequestOptions(),
          ),
        );

        final result = await coffeeRepository.getCoffeeImage();

        expect(result, isA<Coffee>());
        expect(result.imageUrl, url);
        verify(() => coffeeApi.getCoffeeImageUrl()).called(1);
      },
    );
  });
}
