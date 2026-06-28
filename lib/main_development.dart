import 'package:injectable/injectable.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/bootstrap.dart';
import 'package:the_usual/firebase_options_development.dart';

Future<void> main() async {
  await bootstrap(() async {
    await configureDependencies(Environment.dev);
    return const TheUsualsApp();
  }, firebaseOptions: DefaultFirebaseOptions.currentPlatform);
}
