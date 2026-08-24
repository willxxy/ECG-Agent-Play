CUDA_VISIBLE_DEVICES=3,5 fairseq-hydra-train \
task.data=/p01/whan/ecg_agent/ECG-Agent-Play/data/physionet_preprocessed/manifest/cmsc \
--config-dir src/fairseq-signals/examples/w2v_cmsc/config/pretraining \
--config-name w2v_cmsc_rlm