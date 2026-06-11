import 'package:dio/dio.dart';
import 'package:flutter_template/app/core/core.dart';
import 'package:injectable/injectable.dart';

/// {@template coffee_api}
/// A service class that acts as a high-level interface for network requests.
///
/// This class uses [RestClient] to communicate with the backend and leverages
/// [Endpoints] for centralized route management.
/// {@endtemplate}
@singleton
class CoffeeApi {
  /// {@macro coffee_api}
  CoffeeApi(this._client);

  final RestClient _client;

  /// Fetches a random coffee image URL.
  Future<Response<dynamic>> getCoffeeImageUrl() async {
    return _client.request(Endpoints.coffee.random, HttpMethod.get);
  }
}
