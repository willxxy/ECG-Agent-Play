import ast
from pathlib import Path
import numpy as np
import pandas as pd
from scipy.io import loadmat

metadata = pd.read_csv("src/ptbxl_files/ptbxl_database.csv")
classes = sorted({
    code
    for codes in metadata["scp_codes"].map(ast.literal_eval)
    for code in codes
})

files = list(Path("data/ptbxl_preprocessed/mat_files").glob("*.mat"))
counts = np.zeros(len(classes), dtype=int)

for path in files:
    labels = loadmat(path, variable_names=["label"])["label"].ravel()
    counts += labels.astype(int)

distribution = pd.DataFrame({
    "label": classes,
    "count": counts,
    "percent": 100 * counts / len(files),
})

print(f"Total ECGs: {len(files)}")
print(distribution.sort_values("count", ascending=False).round(2).to_string(index=False))