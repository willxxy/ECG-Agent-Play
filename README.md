<div align="center">

<h1> ECG-Agent: On-Device Tool-Calling Agent for ECG Multi-Turn Dialogue </h1>

<h5 align="center"> 

<a href='https://arxiv.org/abs/2601.20323'><img src='https://img.shields.io/badge/Paper-Arxiv-red'></a>
<a href='https://huggingface.co/gustmd0121'><img src='https://img.shields.io/badge/Dataset-Huggingface-yellow'>

<br>

[Hyunseung Chung](https://sites.google.com/view/thschung)<sup>1</sup>,
[Jungwoo Oh](https://github.com/Jwoo5)<sup>1</sup>,
[Daeun Kyung](https://dek924.github.io/)<sup>1</sup>,
[Jiho Kim](https://jiho283.github.io/)<sup>1</sup>,
[Yeonsu Kwon](https://sites.google.com/view/yeonsukwon)<sup>1</sup>,
[Min-Gyu Kim](https://mingyuk.github.io/)<sup>2</sup>,
[Edward Choi](https://mp2893.com/)<sup>1</sup>

<sup>1</sup>KAIST <sup>2</sup>Ajou University School of Medicine

<p align="center">
    <img src="figs/overall_figure.png" width="95%">
</p>

</h5>
</div>

## Clone dependencies

This repository pins fairseq-signals as a Git submodule. Initialize it after cloning:

```bash
git submodule update --init --recursive
```

## Environment

Create the environment with Python 3.11. PyTorch is installed first because FlashAttention needs it at build time.

```bash
uv venv
source .venv/bin/activate
uv pip install -r requirements.txt
```

## Installation Notes (willxxy)
Our server GCC version is 8.5, thus not meeting the requirement for apex (needed for things like `src/fairseq-signals/fairseq_signals/modules/layer_norm.py`).
We use a self-contained GCC 13 package and path to this package using micromamba (largely suggested by ChatGPT). With this modification, we are able to fully install the necessary requirements.

If your GCC version is already up to the date, ignore this and use the original requirements.txt file with `apex==0.9.10dev`.

## Pipeline setup notes

Willxxy own notes when setting up.

1. From the root of this repo, I put the data like so:

    ```
    ECG-Agent-Play
    |__data
        |__physionet_preproccessed
        |__ptbxl_preprocessed
        |__spectralx
    ```

    For every preprocessing script, I pathed the output to one of the following folders above. The organization inside each folder is not too important. Just make sure to preprocess + manifest.

2. I used all default configs for pretraining w2v except for batch size (64 --> 32) due to memory constraints at the time of this readme. The pretraining w2v is being trained on 2 H100 NVL gpus that has other jobs running on it, therefore the convergence may be slower. I will rerun it once its more free but for now it should be fine. 

3. 

## Introduction

Recent advances in Multimodal Large Language Models have rapidly expanded to electrocardiograms, focusing on classification, report generation, and single-turn QA tasks. However, these models fall short in real-world scenarios, lacking multi-turn conversational ability, on-device efficiency, and precise understanding of ECG measurements such as the PQRST intervals.
To address these limitations, we introduce **ECG-Agent**, the first LLM-based tool-calling agent for multi-turn ECG dialogue. To facilitate its development and evaluation, we also present the **ECG-Multi-Turn-Dialogue (ECG-MTD) dataset**, a collection of realistic user-assistant multi-turn dialogues for diverse ECG lead configurations. We develop ECG-Agents in various sizes, from on-device capable (1B, 3B) to larger agents (8B, 32B).
Experimental results show that ECG-Agents outperform baseline ECG-LLMs in response accuracy. Furthermore, on-device agents achieve comparable performance to larger agents in various evaluations that assess response accuracy, tool-calling ability, and hallucinations, demonstrating their viability for real-world applications.

### ECG-MTD Dataset

| Type | 12-lead | Lead I | Lead II |
|------|----------|---------|---------|
| Dataset | [ECG-MTD 12-lead](https://huggingface.co/datasets/gustmd0121/12-lead-ecg-mtd-dataset) | [ECG-MTD Lead I](https://huggingface.co/datasets/gustmd0121/single-lead-I-ecg-mtd-dataset) | [ECG-MTD Lead II](https://huggingface.co/datasets/gustmd0121/single-lead-II-ecg-mtd-dataset) |
| Ground-Truth | [ECG-MTD 12-lead Ground-Truth](https://huggingface.co/datasets/gustmd0121/12-lead-ecg-mtd-dataset-gt) | [ECG-MTD Lead I Ground-Truth](https://huggingface.co/datasets/gustmd0121/single-lead-I-ecg-mtd-dataset-gt) | [ECG-MTD Lead II Ground-Truth](https://huggingface.co/datasets/gustmd0121/single-lead-II-ecg-mtd-dataset-gt) |


## Getting Started

### Classification Tool

#### 1. Pre-processing and Pretraining

For pre-processing PhysioNet2021 and pretraining W2V+CMSC+RLM, follow the instructions in:
- [Fairseq-signals repository](https://github.com/Jwoo5/fairseq-signals) (uni-modal tasks section)
- [W2V+CMSC+RLM guide](https://github.com/Jwoo5/fairseq-signals/blob/master/examples/w2v_cmsc/README.md)

#### 2. Fine-tuning a Pre-trained Model

**Step 2a:** Preprocess the PTB-XL dataset:

```bash
python src/preprocess/preprocess_ptbxl.py \
    /path/to/ptbxl/records500/ \
    --dest /path/to/output
```

**Step 2b:** Generate manifest files for fine-tuning:

```bash
python src/preprocess/manifest_ptbxl_10s.py /path/to/output
```

**Step 2c:** Fine-tune on the Cardiac Arrhythmia Classification task:

```bash
fairseq-hydra-train \
    model.model_path=/path/to/pretrained_model/checkpoints/checkpoint_last.pt \
    +task.data=/path/to/output/from/2b/ptbxl_10s_manifest \
    --config-dir examples/w2v_cmsc/config/finetuning/ecg_transformer \
    --config-name diagnosis
```

#### 3. Extract Tool Outputs

For explanation tool outputs, follow the instructions in: 
[SpectralX repository](https://github.com/gustmd0121/Time_is_not_Enough)

After fine-tuning, use the model to produce tool output CSV files.

**Classification** (requires model path):

```bash
python extract_tool_outputs.py \
    --tool classification \
    --ecg_dir /path/to/ecg/files \
    --model_path /path/to/checkpoint_best.pt \
    --output_dir ./results
```

**Measurements** (no model needed):

```bash
python extract_tool_outputs.py \
    --tool measurements \
    --ecg_dir /path/to/ecg/files \
    --output_dir ./results
```

---

### Fine-tuning ECG-MTD

#### 1. Fine-tune the Model

```bash
python finetune_ecg_dialogue_unsloth.py
```

#### 2. Run Inference

```bash
python inference_ecg_dialogue.py
```

## Citation

If you find this work useful, please cite our paper:

```bibtex
@misc{chung2026ecgagentondevicetoolcallingagent,
      title={ECG-Agent: On-Device Tool-Calling Agent for ECG Multi-Turn Dialogue},
      author={Hyunseung Chung and Jungwoo Oh and Daeun Kyung and Jiho Kim and Yeonsu Kwon and Min-Gyu Kim and Edward Choi},
      year={2026},
      eprint={2601.20323},
      archivePrefix={arXiv},
      primaryClass={cs.AI},
      url={https://arxiv.org/abs/2601.20323},
}
```
