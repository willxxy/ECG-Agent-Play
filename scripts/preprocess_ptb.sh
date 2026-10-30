# uv run python3 src/preprocess/preprocess_ptbxl.py /p01/whan/data/ptb_xl/records500/ --dest ptbxl_preprocessed

# uv run python3 src/preprocess/manifest_ptbxl_10s.py --root ptbxl_preprocessed \
# --dest ptbxl_preprocessed/ptbxl_manifest

uv run python3 src/fairseq-signals/fairseq_signals/data/ecg/preprocess/manifest_physionet2021.py \
/p01/whan/ecg_agent/ECG-Agent-Play/data/physionet_preprocessed \
--dest /p01/whan/ecg_agent/ECG-Agent-Play/data/physionet_preprocessed