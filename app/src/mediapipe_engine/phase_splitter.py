from typing import List, Dict, Any


class PhaseSplitter:
    def split_serve_phases(self, features: List[Dict[str, Any]]) -> Dict[str, Any]:
        if not features:
            return {
                "trophy_phase": None,
                "loading_phase": None,
                "acceleration_phase": None,
                "follow_through_phase": None,
            }

        valid = [f for f in features if f["right_wrist_y"] is not None]
        if not valid:
            return {
                "trophy_phase": None,
                "loading_phase": None,
                "acceleration_phase": None,
                "follow_through_phase": None,
            }

        trophy_frame = min(valid, key=lambda f: f["right_wrist_y"])
        trophy_idx = trophy_frame["frame_index"]

        start_idx = features[0]["frame_index"]
        end_idx = features[-1]["frame_index"]

        return {
            "loading_phase": {
                "start": start_idx,
                "end": max(start_idx, trophy_idx - 1),
            },
            "trophy_phase": {
                "start": trophy_idx,
                "end": trophy_idx,
            },
            "acceleration_phase": {
                "start": min(end_idx, trophy_idx + 1),
                "end": min(end_idx, trophy_idx + 10),
            },
            "follow_through_phase": {
                "start": min(end_idx, trophy_idx + 11),
                "end": end_idx,
            },
        }