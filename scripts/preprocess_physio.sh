uv run python3 src/fairseq-signals/fairseq_signals/data/ecg/preprocess/preprocess_physionet2021.py \
    /p01/whan/data/physionet.org/files/challenge-2021/1.0.3/training \
    --dest data/physionet_preprocessed \
    --workers 8 \
    --meta-dir data/physionet_preprocessed

uv run python3 src/fairseq-signals/fairseq_signals/data/ecg/preprocess/manifest.py \
    data/physionet_preprocessed \
    --dest data/physionet_preprocessed/manifest

uv run python3 src/fairseq-signals/fairseq_signals/data/ecg/preprocess/convert_to_cmsc_manifest.py \
    data/physionet_preprocessed/manifest \
    --dest data/physionet_preprocessed/manifest/w2v_cmsc