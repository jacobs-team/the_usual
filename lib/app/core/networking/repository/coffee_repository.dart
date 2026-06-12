import 'package:injectable/injectable.dart';
import 'package:the_usual/app/app.dart';

/// {@template coffee_repository}
/// A repository that handles data operations for coffee-related resources.
///
/// {@endtemplate}
@singleton
class CoffeeRepository {
  /// {@macro coffee_repository}
  CoffeeRepository(this._coffeeApi);

  final CoffeeApi _coffeeApi;

  /// Fetches a random coffee image.
  Future<Coffee> getCoffeeImage() async {
    final response = await _coffeeApi.getCoffeeImageUrl();
    return mapJson(response.data, Coffee.fromJson);
  }
}
