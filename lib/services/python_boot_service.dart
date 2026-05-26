import 'package:serious_python/serious_python.dart';
import 'analysis_api_service.dart';


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
  static Future<void> waitUntilReady() async {
  for (int i = 0; i < 20; i++) {
    try {
      await AnalysisApiService.healthCheck();
      return;
    } catch (_) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }
  throw Exception('Python server did not become ready');
}
}