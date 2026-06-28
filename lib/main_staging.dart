import 'package:the_usual/app/app.dart';
import 'package:the_usual/bootstrap.dart';
import 'package:the_usual/firebase_options.dart';

Future<void> main() async {
  // TODO(jb): staging points at the production Firebase project. Give it its
  // own project and `firebase_options_staging.dart` before using it to test
  // against real data.
  await bootstrap(
    () => const TheUsualsApp(),
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );
}
