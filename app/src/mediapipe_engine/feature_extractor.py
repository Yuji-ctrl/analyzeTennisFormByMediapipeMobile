from typing import Dict, Any, List, Optional
import math


class FeatureExtractor:
    LEFT_SHOULDER = 11
    RIGHT_SHOULDER = 12
    LEFT_ELBOW = 13
    RIGHT_ELBOW = 14
    LEFT_WRIST = 15
    RIGHT_WRIST = 16
    LEFT_HIP = 23
    RIGHT_HIP = 24
    LEFT_KNEE = 25
    RIGHT_KNEE = 26
    LEFT_ANKLE = 27
    RIGHT_ANKLE = 28
    NOSE = 0

    def _get_point(self, landmarks: List[Dict[str, Any]], idx: int) -> Optional[Dict[str, float]]:
        for lm in landmarks:
            if lm["id"] == idx:
                return lm
        return None

    def _calc_angle(self, a, b, c) -> Optional[float]:
        if not a or not b or not c:
            return None

        ba = (a["x"] - b["x"], a["y"] - b["y"])
        bc = (c["x"] - b["x"], c["y"] - b["y"])

        dot = ba[0] * bc[0] + ba[1] * bc[1]
        norm_ba = math.sqrt(ba[0] ** 2 + ba[1] ** 2)
        norm_bc = math.sqrt(bc[0] ** 2 + bc[1] ** 2)

        if norm_ba == 0 or norm_bc == 0:
            return None

        cos_theta = max(-1.0, min(1.0, dot / (norm_ba * norm_bc)))
        return math.degrees(math.acos(cos_theta))

    def extract_frame_features(self, frame_data: Dict[str, Any]) -> Dict[str, Any]:
        lms = frame_data["landmarks"]

        ls = self._get_point(lms, self.LEFT_SHOULDER)
        rs = self._get_point(lms, self.RIGHT_SHOULDER)
        le = self._get_point(lms, self.LEFT_ELBOW)
        re = self._get_point(lms, self.RIGHT_ELBOW)
        lw = self._get_point(lms, self.LEFT_WRIST)
        rw = self._get_point(lms, self.RIGHT_WRIST)
        lh = self._get_point(lms, self.LEFT_HIP)
        rh = self._get_point(lms, self.RIGHT_HIP)
        lk = self._get_point(lms, self.LEFT_KNEE)
        rk = self._get_point(lms, self.RIGHT_KNEE)
        la = self._get_point(lms, self.LEFT_ANKLE)
        ra = self._get_point(lms, self.RIGHT_ANKLE)
        nose = self._get_point(lms, self.NOSE)

        shoulder_center_y = None
        hip_center_y = None
        if ls and rs:
            shoulder_center_y = (ls["y"] + rs["y"]) / 2
        if lh and rh:
            hip_center_y = (lh["y"] + rh["y"]) / 2

        return {
            "frame_index": frame_data["frame_index"],
            "left_elbow_angle": self._calc_angle(ls, le, lw),
            "right_elbow_angle": self._calc_angle(rs, re, rw),
            "left_knee_angle": self._calc_angle(lh, lk, la),
            "right_knee_angle": self._calc_angle(rh, rk, ra),
            "left_wrist_y": lw["y"] if lw else None,
            "right_wrist_y": rw["y"] if rw else None,
            "nose_y": nose["y"] if nose else None,
            "shoulder_center_y": shoulder_center_y,
            "hip_center_y": hip_center_y,
        }

    def extract_sequence_features(self, pose_frames: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        return [self.extract_frame_features(frame) for frame in pose_frames]