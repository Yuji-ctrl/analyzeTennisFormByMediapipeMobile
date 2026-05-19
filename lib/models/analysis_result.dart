class AnalysisResult {
  const AnalysisResult({
    required this.sourceLabel,
    required this.similarityPercent,
  });

  final String sourceLabel;
  final int similarityPercent;
}