#!/usr/bin/env bash

raw_audio_dir=/Users/myixiong/data/LibriSpeech/train-clean-100

train_data=/Users/myixiong/data/LibriSpeech/data-train
if [ ! -d ${train_data} ]; then mkdir ${train_data}; fi

utt2spk=${train_data}/utt2spk
if [ ! -d ${utt2spk} ]; then touch ${utt2spk}; fi
cat /dev/null > ${utt2spk}

wav_scp=${train_data}/wav.scp
if [ ! -d ${wav_scp} ]; then touch ${wav_scp}; fi
cat /dev/null > ${wav_scp}

counter=0
for user_dir in ${raw_audio_dir}/*; do
    for segment in ${user_dir}/*; do
        for raw_audio in ${segment}/*.flac; do
            base_name=$(basename -s .flac ${raw_audio})
            ffmpeg -i ${raw_audio} ${train_data}/${base_name}-16k.wav > /dev/null 2>&1
            sox ${train_data}/${base_name}-16k.wav -r 8000 ${train_data}/${base_name}.wav > /dev/null 2>&1
            rm ${train_data}/${base_name}-16k.wav
            spkr=${user_dir##*/}
            echo "${base_name} ${spkr}" >> ${utt2spk}
            echo "${base_name} ${train_data}/${base_name}.wav" >> ${wav_scp}
            counter=$((counter+1))
            echo "${train_data}/${base_name}.wav"
            echo "$counter"
        done
    done
done