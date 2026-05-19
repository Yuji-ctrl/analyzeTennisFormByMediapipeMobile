import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'loading_page.dart';

class PickedVideoPreviewPage extends StatefulWidget {
  const PickedVideoPreviewPage({
    super.key,
    required this.videoPath,
    required this.sourceLabel,
  });

  final String videoPath;
  final String sourceLabel;

  @override
  State<PickedVideoPreviewPage> createState() => _PickedVideoPreviewPageState();
}

class _PickedVideoPreviewPageState extends State<PickedVideoPreviewPage> {
  VideoPlayerController? _controller;
  bool _isInitializing = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      final controller = VideoPlayerController.file(File(widget.videoPath));
      await controller.initialize();
      await controller.setLooping(true);

      if (!mounted) {
        controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _isInitializing = false;
      });
    } catch (e) {
      setState(() {
        _isInitializing = false;
        _errorMessage = '動画の読み込みに失敗しました: $e';
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Scaffold(
      appBar: AppBar(
        title: const Text('動画確認'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _isInitializing
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: double.infinity,
                            color: Colors.black,
                            child: controller != null &&
                                    controller.value.isInitialized
                                ? AspectRatio(
                                    aspectRatio: controller.value.aspectRatio,
                                    child: VideoPlayer(controller),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                if (controller == null) return;
                                if (controller.value.isPlaying) {
                                  controller.pause();
                                } else {
                                  controller.play();
                                }
                                setState(() {});
                              },
                              icon: Icon(
                                controller?.value.isPlaying == true
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                              label: Text(
                                controller?.value.isPlaying == true
                                    ? '一時停止'
                                    : '再生',
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LoadingPage(
                                      sourceLabel: widget.sourceLabel,
                                      videoPath: widget.videoPath,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.analytics_outlined),
                              label: const Text('分析開始'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
      ),
    );
  }
}