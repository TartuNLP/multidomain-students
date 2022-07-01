#!/bin/bash

# set GPUS and marian location
GPUS="1"
MARIAN=marian-dev/build

SRCLANG=et
TGTLANG=en

# Download and uncompress models and test sets
wget https://owncloud.ut.ee/owncloud/index.php/s/it7yC5nakFder5a/download/finetuned-students.tar.gz

tar -xf finetuned-students.tar.gz

TEST_SETS_PATH=finetuned-students/test-sets
MODELS_PATH=finetuned-students/models
OUT_PATH=finetuned-students/test-translations
LOGS_DIR=${OUT_PATH}

mkdir -p ${OUT_PATH}

# Evaluate on held-out sets
echo "Held-out test sets"

for student_model in S0 S-FT S-FT-bal
do
  STUDENT_PATH=$MODELS_PATH/$student_model
  for corpus in Europarl GNOME KDE4 Ubuntu DGT JRC-Acquis EMEA OpenSubtitles infopankki ParaCrawl
  do
    test_src=${TEST_SETS_PATH}/shuf-${corpus}.test.${SRCLANG}
    test_tgt=${TEST_SETS_PATH}/shuf-${corpus}.test.${TGTLANG}

    echo $student_model
    echo $corpus
    cat $test_src \
    |$MARIAN/marian-decoder \
    --config ${STUDENT_PATH}/model.npz.best-bleu-detok.npz.decoder.yml \
    --quiet --log $LOGS_DIR/transl_${student_model}_${corpus}.log --devices $GPUS $@ \
    | tee $OUT_PATH/transl-${student_model}-$corpus.$TGTLANG \
    | sacrebleu $test_tgt
  done
done

# Evaluate on WMT18
echo "WMT18 test set"

test_src=${TEST_SETS_PATH}/wmt18.${SRCLANG}-${TGTLANG}.src
test_tgt=${TEST_SETS_PATH}/wmt18.${SRCLANG}-${TGTLANG}.ref

for student_model in S0 S-FT S-FT-bal
do
  STUDENT_PATH=$MODELS_PATH/$student_model
  echo $student_model
  cat $test_src \
  |$MARIAN/marian-decoder \
  --config ${STUDENT_PATH}/model.npz.best-bleu-detok.npz.decoder.yml \
  --quiet --log $LOGS_DIR/transl_${student_model}_wmt.log --devices $GPUS $@ \
  | tee $OUT_PATH/transl-${student_model}-wmt.$TGTLANG \
  | sacrebleu $test_tgt
done
