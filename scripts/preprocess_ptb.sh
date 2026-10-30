uv run python3 src/preprocess/preprocess_ptbxl.py /p01/whan/data/ptb_xl/records500/ --dest /p01/whan/ecg_agent/ECG-Agent-Play/data/ptbxl_preprocessed/mat_files

uv run python3 src/preprocess/manifest_ptbxl_10s.py --root /p01/whan/ecg_agent/ECG-Agent-Play/data/ptbxl_preprocessed \
--dest /p01/whan/ecg_agent/ECG-Agent-Play/data/ptbxl_preprocessed/ptbxl_manifest
