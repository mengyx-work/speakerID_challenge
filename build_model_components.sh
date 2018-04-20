#!/usr/bin/env bash

root_dir=/Users/myixiong/data/LibriSpeech
exp=${root_dir}/speaker_id_models
if [ ! -d ${exp} ]; then mkdir ${exp}; fi

num_components=400
num_iters_ivec=4
num_iters_full_ubm=8
ivec_dim=200

echo "### Training diag UBM ###"

sid/train_diag_ubm.sh \
    --cmd './utils/run.pl' \
    --nj 4 \
    ${root_dir}/data-train \
    $num_components \
    ${exp}/diag_ubm_$num_components

echo "### Training full UBM ###"

sid/train_full_ubm.sh \
    --cmd './utils/run.pl' \
    --nj 4 \
    --num-iters ${num_iters_full_ubm} \
    ${root_dir}/data-train \
    ${exp}/diag_ubm_$num_components \
    ${exp}/full_ubm_$num_components

echo "### Training ivector extractor ###"

sid/train_ivector_extractor.sh \
    --cmd './utils/run.pl' \
    --nj 4 \
    --ivector-dim ${ivec_dim} \
    --num-iters ${num_iters_ivec} \
    ${exp}/full_ubm_$num_components/final.ubm \
    ${exp}/data-train \
    ${exp}/extractor