import 'package:flutter/material.dart';
import 'package:serious_python/serious_python.dart';
import 'package:http/http.dart' as http;
import '../models/analysis_result.dart';
import 'result_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({
    super.key,
    required this.videoPath,
  });

  final String videoPath;

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _runCheck();
  }

  Future<void> _mockAnalyze() async {
    try{}
    await SeriousPython.run("app/app.zip");
    await Future.delayed(const Duration(seconds: 3));
    final healthUri = Uri.parse('http://127.0.0.1:8000/health');
      final response = await http.get(healthUri);
    if (!mounted) return;

if (response.statusCode == 200) {
    final result = AnalysisResult(
  sourceLabel: 'video',
  similarityPercent: 82 + Random().nextInt(14),
  videoPath: widget.videoPath,
);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultPage(result: result),
      ),
    );
  }else{
    _showError('Python API returned ${response.statusCode}');
  }catch(e){if (!mounted) return;
      _showError('Python起動または接続確認に失敗しました: $e');
    }
  }

  void _showError(String message) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('エラー')),
          body: Center(child: Text(message)),
        ),),
    );
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