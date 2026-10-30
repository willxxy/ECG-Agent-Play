CUDA_VISIBLE_DEVICES=2,5,6,7 fairseq-hydra-train \
model.model_path=/p01/whan/ecg_agent/ECG-Agent-Play/outputs/2026-10-28/13-49-34/checkpoints/checkpoint_last.pt \
task.data=/p01/whan/ecg_agent/ECG-Agent-Play/data/ptbxl_preprocessed/ptbxl_manifest \
model.num_labels=71 \
--config-dir src/fairseq-signals/examples/w2v_cmsc/config/finetuning/ecg_transformer \
--config-name diagnosis