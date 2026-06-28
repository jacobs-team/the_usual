import 'package:the_usual/app/app.dart';
import 'package:the_usual/bootstrap.dart';
import 'package:the_usual/firebase_options.dart';

Future<void> main() async {
  // staging points to prod
  await bootstrap(
    () => const TheUsualsApp(),
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );
}
