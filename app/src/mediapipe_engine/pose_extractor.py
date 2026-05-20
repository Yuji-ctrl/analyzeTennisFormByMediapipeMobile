from typing import List, Dict, Any
import cv2
import mediapipe as mp


class PoseExtractor:
    def __init__(
        self,
        static_image_mode: bool = False,
        model_complexity: int = 1,
        min_detection_confidence: float = 0.5,
        min_tracking_confidence: float = 0.5,
    ):
        self.mp_pose = mp.solutions.pose
        self.pose = self.mp_pose.Pose(
            static_image_mode=static_image_mode,
            model_complexity=model_complexity,
            min_detection_confidence=min_detection_confidence,
            min_tracking_confidence=min_tracking_confidence,
        )

    def extract_from_video(self, video_path: str) -> List[Dict[str, Any]]:
        cap = cv2.VideoCapture(video_path)
        frames = []
        frame_index = 0

        while cap.isOpened():
            ret, frame = cap.read()
            if not ret:
                break

            rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            result = self.pose.process(rgb)

            landmarks = []
            if result.pose_landmarks:
                for i, lm in enumerate(result.pose_landmarks.landmark):
                    landmarks.append({
                        "id": i,
                        "x": lm.x,
                        "y": lm.y,
                        "z": lm.z,
                        "visibility": lm.visibility,
                    })

            frames.append({
                "frame_index": frame_index,
                "width": frame.shape[1],
                "height": frame.shape[0],
                "landmarks": landmarks,
            })
            frame_index += 1

        cap.release()
        return frames