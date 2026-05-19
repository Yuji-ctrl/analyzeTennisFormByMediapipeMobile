import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/material.dart';

import '../models/analysis_result.dart';
import '../services/python_boot_service.dart';
import '../services/analysis_api_service.dart';
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
  }Future<void> _runCheck() async {
  try {
    await PythonBootService.ensureStarted();

    await Future.delayed(const Duration(seconds: 2));

    final health = await AnalysisApiService.healthCheck();
    final echo = await AnalysisApiService.echo("hello from flutter");

    if (!mounted) return;

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
  } catch (e) {
    if (!mounted) return;
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
      ),
    ),
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