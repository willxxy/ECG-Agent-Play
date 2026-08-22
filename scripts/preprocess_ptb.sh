# uv run python3 src/preprocess/preprocess_ptbxl.py /p01/whan/data/ptb_xl/records500/ --dest ptbxl_preprocessed

uv run python3 src/preprocess/manifest_ptbxl_10s.py --root ptbxl_preprocessed \
--data mat_files \
--valid-percent 0.05 \
--test-percent 0.15 \
--dest ptbxl_preprocessed/ptbxl_manifest
