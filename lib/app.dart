import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'routes.dart';
import 'screens/home_page.dart';

class FormAnalysisApp extends StatelessWidget {
  const FormAnalysisApp({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'フォーム分析',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: HomePage(cameras: cameras),
      routes: {
        AppRoutes.loading: (context) => const SizedBox.shrink(),
        AppRoutes.result: (context) => const SizedBox.shrink(),
      },
    );
  }
}