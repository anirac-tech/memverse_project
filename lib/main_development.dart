import 'package:memverse/src/app/app.dart';
import 'package:memverse/src/bootstrap.dart';

void main() {
  // Use the CLIENT_ID from dart-define parameter
  developer.log(
    'Pipeline check - MEM-115 custom lint package moved to separate ticket',
    name: 'memverse.pipeline',
  );
  bootstrap(() => const App());
}
