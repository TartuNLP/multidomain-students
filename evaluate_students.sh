#!/bin/bash

# set GPUS and marian location
GPUS="1"
MARIAN=marian-dev/build

SRCLANG=et
TGTLANG=en

# Download and uncompress models and test sets
wget https://owncloud.ut.ee/owncloud/index.php/s/it7yC5nakFder5a/download/finetuned-students.tar.gz

tar -xf finetuned-students.tar.gz

TEST_SETS_PATH=test-sets
OUT_PATH=test-translations
LOGS_DIR=${OUT_PATH}

mkdir -p ${OUT_PATH}

# Evaluate on held-out test sets
echo "Held-out test sets"
echo "STUDENT-0"

STUDENT_PATH=models/student-from-teacher-0
for corpus in Europarl GNOME KDE4 Ubuntu DGT JRC-Acquis EMEA OpenSubtitles infopankki ParaCrawl
do
  test_src=${TEST_SETS_PATH}/shuf-${corpus}.test.${SRCLANG}
  test_tgt=${TEST_SETS_PATH}/shuf-${corpus}.test.${TGTLANG}
  
  echo $corpus
  cat $test_src \
  |$MARIAN/marian-decoder \
  --config ${STUDENT_PATH}/model.npz.best-bleu-detok.npz.decoder.yml \
  --quiet --log $LOGS_DIR/transl_student_t0_${corpus}.log --devices $GPUS $@ \
  | tee $OUT_PATH/transl-student-t0-$corpus.$TGTLANG \
  | sacrebleu $test_tgt
done

echo "STUDENT-FT"
STUDENT_PATH=models/student-from-teachers-ft
for corpus in Europarl GNOME KDE4 Ubuntu DGT JRC-Acquis EMEA OpenSubtitles infopankki ParaCrawl
do
  test_src=${TEST_SETS_PATH}/shuf-${corpus}.test.${SRCLANG}
  test_tgt=${TEST_SETS_PATH}/shuf-${corpus}.test.${TGTLANG}
  
  echo $corpus
  cat $test_src \
  |$MARIAN/marian-decoder \
  \--config ${STUDENT_PATH}/model.npz.best-bleu-detok.npz.decoder.yml \
  --quiet --log $LOGS_DIR/transl_student_tft_${corpus}.log --devices $GPUS $@ \
  | tee $OUT_PATH/transl-student-tft-$corpus.$TGTLANG \
  | sacrebleu $test_tgt
done

# Evaluate on WMT18
echo "WMT18 test set"

test_src=${TEST_SETS_PATH}/wmt18.${SRCLANG}-${TGTLANG}.src
test_tgt=${TEST_SETS_PATH}/wmt18.${SRCLANG}-${TGTLANG}.ref
STUDENT_PATH=models/student-from-teacher-0
echo "STUDENT-0"
cat $test_src \
|$MARIAN/marian-decoder \
--config ${STUDENT_PATH}/model.npz.best-bleu-detok.npz.decoder.yml \
--quiet --log $LOGS_DIR/transl_student_t0_wmt.log --devices $GPUS $@ \
| tee $OUT_PATH/transl-student-t0-wmt.$TGTLANG \
| sacrebleu $test_tgt

STUDENT_PATH=models/student-from-teachers-ft
echo "STUDENT-FT"
cat $test_src \
|$MARIAN/marian-decoder \
--config ${STUDENT_PATH}/model.npz.best-bleu-detok.npz.decoder.yml \
--quiet --log $LOGS_DIR/transl_student_tft_wmt.log --devices $GPUS $@ \
| tee $OUT_PATH/transl-student-tft-wmt.$TGTLANG \
| sacrebleu $test_tgt
