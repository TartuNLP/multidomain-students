# Multidomain student models (ET-EN)

Paper: [Distilling Estonian Text Domains for Production-Oriented Machine Translation](https://openreview.net/forum?id=caHZwr_4fee)

## Usage

To download and evaluate student models, set the `GPUS` and `MARIAN` variables in `evaluate_students.sh` and run the script.

Requirements: `marian`, `sacrebleu`

Test sets and their translations by the student models provided in `test-set-translations`. 

## Results

We used 10 corpora which we split into 6 groups:
   - EUPARL (Europarl)
   - IT (GNOME, KDE4, Ubuntu)
   - LEGAL (DGT, JRC-Acquis)
   - MEDICAL (EMEA)
   - SUBS (OpenSubtitles)
   - WEB (ParaCrawl, infopankki)

We compare the student model trained on the original teacher's translations (S0)
 to a student trained on fine-tuned teachers' forward-translations (S-FT),
 as well as a student trained on fine-tuned teachers' forward-translations but with all data groups balanced to have the same total size (S-FT-bal).

BLEU on held-out test sets and WMT18: 

| corpus  | Europarl | GNOME | KDE4 | Ubuntu | DGT   | JRC-Acquis | EMEA    | OpenSubtitles | ParaCrawl | infopankki | WMT      | average  |
|---------|:--------:|:-----:|:----:|:------:|:-----:|:----------:|:-------:|:-------------:|:---------:|:----------:|----------|----------|
| group   |  EUPARL  |   IT  |  IT  |   IT   | LEGAL |    LEGAL   | MEDICAL |      SUBS     |    WEB    |     WEB    | NEWS     |          |
| S0      | 38.4     | 29.3  |**25.2**| 31.4 | 40.4  | 54.3     | 42.6    |**29.7**         | 47.0      | 28.8       | 28.3     | 35.945   |
| S-FT    | 38.3     | 29.0  | 25.0 | 31.6   |**41.3**|**54.5**   | 41.3    |**29.7**       |**48.6**   |**30.6**    | 28.5     | 36.218   |
| S-FT-bal| 38.2     |**45.6**| 23.7 |**45.3**| 38.8  | 50.9       |**49.3**| 27.3          | 41.6      | 25.0       | 26.2     |**37.445**|

Teachers' BLEU (original and fine-tuned) on the same test sets:

| corpus    | Europarl | GNOME | KDE4 | Ubuntu | DGT   | JRC-Acquis | EMEA    | OpenSubtitles | ParaCrawl | infopankki | WMT  |
|-----------|:--------:|:-----:|:----:|:------:|:-----:|:----------:|:-------:|:-------------:|:---------:|:----------:|------|
| group     |  EUPARL  |   IT  |  IT  |   IT   | LEGAL |    LEGAL   | MEDICAL |      SUBS     |    WEB    |     WEB    | NEWS |
| T0        | 40.9     | 33.8  | 29.7 | 37.8   | 44.2  | 57.5       | 46.8    | 31.9          | 50.5      | 30.9       | 30.4 |
| T-EUPARL  |**42.8**  | 11.0  | 11.7 | 13.8   | 27.6  | 36.9       | 17.6    | 18.4          | 23.9      | 20.3       | 22.6 |
| T-IT      | 9.2      |**61.2**|**40.6**|**55.7**| 6.9   | 6.5     | 10.4    | 10.5          | 14.3      | 9.2        | 9.0  |
| T-LEGAL   | 29.4     | 17.1  | 12.7 | 18.3   |**49.7**|**64.6**   | 24.3    | 8.1           | 23.8      | 16.9       | 16.5 |
| T-MEDICAL | 9.6      | 9.4   | 7.3  | 8.4    | 12.7  | 15.4       |**66.3** | 4.4           | 10.7      | 7.3        | 7.2  |
| T-SUBS    | 22.2     | 14.6  | 10.4 | 15.3   | 10.8  | 10.4       | 12.3    |**35.0**       | 21.7      | 16.6       | 24.7 |
| T-WEB     | 38.2     | 29.5  | 23.5 | 33.0   | 36.4  | 50.2       | 39.4    | 24.9          |**52.3**   |**37.4**    |**30.8**|
| T-NEWS    | 37.7     | 24.3  | 20.9 | 27.1   | 28.8  | 38.4       | 29.5    | 28.7          | 35.4      | 27.0       | 30.4 |
