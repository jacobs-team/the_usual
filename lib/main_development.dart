import 'package:flutter_template/app/app.dart';
import 'package:flutter_template/app/core/dependencies/dependencies.dart';
import 'package:flutter_template/bootstrap.dart';
import 'package:injectable/injectable.dart';

Future<void> main() async {
  await bootstrap(() async {
    await configureDependencies(Environment.dev);
    return const CoffeeApp();
  });
}
