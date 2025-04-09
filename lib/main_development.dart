import 'package:memverse/src/app/app.dart';
import 'package:memverse/src/bootstrap.dart';

void main() {
  // Use the CLIENT_ID from dart-define parameter
  bootstrap(() => const App());
}
