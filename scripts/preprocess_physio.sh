uv run python3 src/fairseq-signals/fairseq_signals/data/ecg/preprocess/preprocess_physionet2021.py \
    /p01/whan/data/physionet.org/files/challenge-2021/1.0.3/training \
    --dest data/physionet_preprocessed \
    --workers 8

# uv run python3 src/fairseq-signals/fairseq_signals/data/ecg/preprocess/convert_to_cmsc_manifest.py \
#     /