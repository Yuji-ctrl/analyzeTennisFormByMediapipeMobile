import 'package:serious_python/serious_python.dart';

class PythonBootService {
  static bool _started = false;

  static Future<void> ensureStarted() async {
    if (_started) return;

    await SeriousPython.run(
      "app/app.zip",
      sync: false,
    );

    _started = true;
  }
}