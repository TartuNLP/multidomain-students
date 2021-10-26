# Multidomain student models (ET-EN)

To download and evaluate the fine-tuned student, set the `GPUS` and `MARIAN` variables in `evaluate_students.sh` and run the script.

Currently, we are using the method from [Distilling Multiple Domains for Neural Machine Translation](https://aclanthology.org/2020.emnlp-main.364.pdf):

1. Train general teacher (we used [this one trained by UEDIN]( http://data.statmt.org/romang/bergamot/models/eten.teacher.checkpoints.tgz))
2. Fine-tune teacher to multiple domains. We used 10 corpora which we split into 6 groups:
   - EUPARL (Europarl)
   - IT (GNOME, KDE4, Ubuntu)
   - LEGAL (DGT, JRC-Acquis)
   - MEDICAL (EMEA)
   - SUBS (OpenSubtitles)
   - WEB (ParaCrawl, infopankki)
3. Forward-translate training data with the corresponding fine-tuned teachers
4. Train one student on the concatenation of all forward-translated data

We compare the student trained on fine-tuned teachers' forward-translations (S-FT) to a student trained on the original teacher's translations (S0) and the UEDIN WMT student (S-UEDIN). BLEU on held-out test sets and WMT18: 

| corpus  | Europarl | GNOME | KDE4 | Ubuntu | DGT   | JRC-Acquis | EMEA    | OpenSubtitles | ParaCrawl | infopankki | WMT  |
|---------|:--------:|:-----:|:----:|:------:|:-----:|:----------:|:-------:|:-------------:|:---------:|:----------:|------|
| group   |  EUPARL  |   IT  |  IT  |   IT   | LEGAL |    LEGAL   | MEDICAL |      SUBS     |    WEB    |     WEB    | NEWS |
| S-UEDIN | **41.9** | 20.8  | 18.4 | 25.3   | 30.0  | 37.1       | 26.8    | 28.0          | 31.8      | 25.9       | **31.9** |
| S0      | 32.1     | 21.3  | 19.1 | 24.2   | 24.7  | 29.2       | 27.0    | 27.5          | 31.9      | 25.7       | 27.2 |
| S-FT    | 38.3     |**28.1**|**25.0**|**29.7**|**40.1**|**53.7**| **41.4**| **30.0**      | **44.1**  | **29.7**   | 26.7 |

Teachers' BLEU (original and fine-tuned) on the same test sets:

| corpus    | Europarl | GNOME | KDE4 | Ubuntu | DGT   | JRC-Acquis | EMEA    | OpenSubtitles | ParaCrawl | infopankki | WMT  |
|-----------|:--------:|:-----:|:----:|:------:|:-----:|:----------:|:-------:|:-------------:|:---------:|:----------:|------|
| group     |  EUPARL  |   IT  |  IT  |   IT   | LEGAL |    LEGAL   | MEDICAL |      SUBS     |    WEB    |     WEB    | NEWS |
| T0        | 33.1     | 21.4  | 19.9 | 24.1   | 23.6  | 27.3       | 27.2    | 28.5          | 31.2      | 24.4       |**33.4**|
| T-EUPARL  | **43.7** | 15.8  | 17.1 | 18.3   | 27.7  | 35.6       | 24.6    | 24.1          | 30.2      | 26.4       | 29.9 |
| T-IT      | 12.4     |**63.3**|**37.8**|**54.7**| 8.3   | 8.4        | 12.8    | 14.5          | 16.9      | 10.2       | 13.4 |
| T-LEGAL   | 26.9     | 14.6  | 12.7 | 16.1   |**42.7**|**57.3**   | 21.1    | 6.8           | 23.2      | 17.9       | 15.3 |
| T-MEDICAL | 8.2      | 7.1   | 5.8  | 6.0    | 12.1  | 14.2       |**63.4** | 3.6           | 9.9       | 7.5        | 6.4  |
| T-SUBS    | 26.3     | 16.3  | 12.9 | 18.0   | 15.5  | 16.4       | 20.3    |**32.6**       | 26.7      | 18.6       | 30.3 |
| T-WEB     | 37.3     | 25.2  | 21.9 | 31.0   | 31.7  | 41.1       | 30.3    | 25.4          |**44.3**   |**31.0**       | 32.7 |


