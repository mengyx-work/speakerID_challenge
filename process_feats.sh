#!/usr/bin/env bash
. ./path.sh || exit 1
. ./cmd.sh || exit 1

root_dir=/Users/myixiong/data/LibriSpeech
data_type="train"
nj=4


echo "#############################################"
echo "### BEGIN FEATURE EXTRACTION ${data_type} ###"
echo "#############################################"

## create spk2utt from utt2spk
utils/utt2spk_to_spk2utt.pl ${root_dir}/data-${data_type}/utt2spk > ${root_dir}/data-${data_type}/spk2utt

echo "### MAKE MFCCs ###";

##  --cmd './utils/run.pl'
steps/make_mfcc.sh \
    --cmd ${cmd} \
    --nj $nj \
    --mfcc-config "conf/mfcc.conf" \
    ${root_dir}/data-${data_type}\
    ${root_dir}/feats-${data_type}/log \
    ${root_dir}/feats-${data_type} \
    || printf "\n####\n#### ERROR: make_mfcc.sh \n####\n\n" \
    || exit 1;


echo "### MAKE VAD ###";

# we remove silence frames according to VAD (Matejka etal 2011)
#    --cmd './utils/run.pl'
sid/compute_vad_decision.sh \
    --cmd ${cmd} \
    --nj $nj \
    --vad-config "conf/vad.conf" \
    ${root_dir}/data-${data_type}\
    ${root_dir}/feats-${data_type}/vad_log \
    ${root_dir}/feats-${data_type} \
    || printf "\n####\n#### ERROR: compute_vad_decision.sh \n####\n\n" \
    || exit 1;


./utils/fix_data_dir.sh ${root_dir}/data-${data_type}