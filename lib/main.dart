import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:memverse/firebase_options.dart';
import 'package:memverse/src/app/app.dart';
import 'package:memverse/src/bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await bootstrap(() => const App());
}
