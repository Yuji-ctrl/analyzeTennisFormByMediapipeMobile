from typing import List, Dict, Any, Optional
import math


class SimilarityCalculator:
    FEATURE_KEYS = [
        "left_elbow_angle",
        "right_elbow_angle",
        "left_knee_angle",
        "right_knee_angle",
        "left_wrist_y",
        "right_wrist_y",
        "nose_y",
        "shoulder_center_y",
        "hip_center_y",
    ]

    def _to_vector(self, feature: Dict[str, Any]) -> List[float]:
        vec = []
        for key in self.FEATURE_KEYS:
            value = feature.get(key)
            vec.append(0.0 if value is None else float(value))
        return vec

    def cosine_similarity(self, a: List[float], b: List[float]) -> float:
        dot = sum(x * y for x, y in zip(a, b))
        norm_a = math.sqrt(sum(x * x for x in a))
        norm_b = math.sqrt(sum(y * y for y in b))
        if norm_a == 0 or norm_b == 0:
            return 0.0
        return dot / (norm_a * norm_b)

    def compare_sequences(
        self,
        seq1: List[Dict[str, Any]],
        seq2: List[Dict[str, Any]],
    ) -> Dict[str, Any]:
        if not seq1 or not seq2:
            return {"score": 0.0, "frame_scores": []}

        n = min(len(seq1), len(seq2))
        scores = []

        for i in range(n):
            v1 = self._to_vector(seq1[i])
            v2 = self._to_vector(seq2[i])
            score = self.cosine_similarity(v1, v2)
            scores.append(score)

        final_score = sum(scores) / len(scores) if scores else 0.0

        return {
            "score": round(final_score, 4),
            "frame_scores": [round(s, 4) for s in scores],
        }