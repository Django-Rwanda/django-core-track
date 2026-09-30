"""
Week 2 Test Configuration
Isolates Week 2 starter workspace and settings from other labs.
"""
import os
import sys
from pathlib import Path

# Add Week 2 starter directory to sys.path
starter_dir = Path(__file__).resolve().parent.parent / "starter"
if str(starter_dir) not in sys.path:
    sys.path.insert(0, str(starter_dir))

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "core.settings")
