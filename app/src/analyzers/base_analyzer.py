from abc import ABC, abstractmethod
from typing import Any, Dict


class BaseAnalyzer(ABC):
    @abstractmethod
    def analyze(self, video_path: str) -> Dict[str, Any]:
        pass