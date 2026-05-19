class AnalysisResult {
  const AnalysisResult({
    required this.sourceLabel,
    required this.similarityPercent,
    required this.videoPath,
  });

  final String sourceLabel;
  final int similarityPercent;
  final String? videoPath;
}