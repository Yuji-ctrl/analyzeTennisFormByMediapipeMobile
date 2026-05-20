from typing import Any, Dict

from analyzers.base_analyzer import BaseAnalyzer
from mediapipe_engine.pose_extractor import PoseExtractor
from mediapipe_engine.feature_extractor import FeatureExtractor
from mediapipe_engine.phase_splitter import PhaseSplitter


class TennisServeAnalyzer(BaseAnalyzer):
    def __init__(self):
        self.pose_extractor = PoseExtractor()
        self.feature_extractor = FeatureExtractor()
        self.phase_splitter = PhaseSplitter()

    def analyze(self, video_path: str) -> Dict[str, Any]:
        pose_frames = self.pose_extractor.extract_from_video(video_path)
        features = self.feature_extractor.extract_sequence_features(pose_frames)
        phases = self.phase_splitter.split_serve_phases(features)

        return {
            "video_path": video_path,
            "total_frames": len(pose_frames),
            "features": features,
            "phases": phases,
        }