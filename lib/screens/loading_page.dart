import 'package:flutter/material.dart';
import '../services/python_boot_service.dart';
import '../services/analysis_api_service.dart';
import 'result_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _runCheck();
  }

  Future<void> _runCheck() async {
    try {
      await PythonBootService.ensureStarted();

      await Future.delayed(const Duration(seconds: 2));

      final health = await AnalysisApiService.healthCheck();
      final echo = await AnalysisApiService.echo("hello from flutter");

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(
            resultText:
                'health: ${health['message']}\necho: ${echo['echo']}\nsource: ${echo['source']}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(
            resultText: 'Python API connection failed\n$e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}