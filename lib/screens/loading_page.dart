import 'dart:math';

import 'package:flutter/material.dart';

import '../models/analysis_result.dart';
import 'result_page.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({
    super.key,
    required this.sourceLabel,
    this.videoPath,
  });

  final String sourceLabel;
  final String? videoPath;

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _mockAnalyze();
  }

  Future<void> _mockAnalyze() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final result = AnalysisResult(
      sourceLabel: widget.sourceLabel,
      similarityPercent: 82 + Random().nextInt(14),
      videoPath: widget.videoPath,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultPage(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(strokeWidth: 6),
              SizedBox(height: 24),
              Text(
                '分析中...',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'MediaPipeで骨格動作を解析しています',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}