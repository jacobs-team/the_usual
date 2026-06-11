import 'package:the_usual/app/app.dart';
import 'package:the_usual/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const CoffeeApp());
}
