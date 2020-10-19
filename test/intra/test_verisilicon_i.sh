#!/bin/bash
#-------------------------------------------------------------------
#
#  Filename      : test_sequece
#  Author        : Gu Chen Hao
#  Created       : 2019-02-27
#  Description   : run verisilicon automatically
#
#-------------------------------------------------------------------

# parameter
SEQ_DIR="/mnt/e/MyFile/VideoCoding/testfiles/HM"
RLT_DIR="result"
RLT_LOG="result.log"
SEQ_LST=(
         "BasketballPass"   416   240   60 8
         "BQSquare"         416   240   60 8
         "BlowingBubbles"   416   240   60 8
         "RaceHorses"       416   240   60 8
         "BasketballDrill"  832   480   60 8
         "BQMall"           832   480   60 8
         "PartyScene"       832   480   60 8
         "RaceHorsesC"      832   480   60 8
         "FourPeople"       1280  720   60 8
         "Johnny"           1280  720   60 8
         "KristenAndSara"   1280  720   60 8
         "Kimono"           1920  1080  60 8
         "ParkScene"        1920  1080  60 8
         "Cactus"           1920  1080  60 8
         "BasketballDrive"  1920  1080  60 8
         "BQTerrace"        1920  1080  60 8
         "Traffic"          2560  1600  60 8
         "PeopleOnStreet"   2560  1600  60 8
        )
QP_LST=(22 27 32 37)
FRAME_LEN=15    # 0 stands for inf
FRAME_BGN=0
GOP_VAL=15     # 0 stands for inf

# directory
mkdir -p $RLT_DIR
printf "%-48s %s\n" "I frame" "P frame" > $RLT_DIR/$RLT_LOG
printf "%-15s %-9s %-9s %-9s    "  "bitrate(kb/s)" "psnr(Y)" "psnr(U)" "psnr(V)" >> $RLT_DIR/$RLT_LOG
printf "%-15s %-9s %-9s %-9s\n"    "bitrate(kb/s)" "psnr(Y)" "psnr(U)" "psnr(V)" >> $RLT_DIR/$RLT_LOG

# time
time_bgn_all=$(date +%s)

# for sequence
seq_pnt=0
seq_lst_len=${#SEQ_LST[*]}
while [ $seq_pnt -lt $seq_lst_len ]
do
  # parameter
  SEQ_STR=${SEQ_LST[ $((seq_pnt + 0)) ]}
  SEQ_WID=${SEQ_LST[ $((seq_pnt + 1)) ]}
  SEQ_HEI=${SEQ_LST[ $((seq_pnt + 2)) ]}
  SEQ_FPS=${SEQ_LST[ $((seq_pnt + 3)) ]}
  SEQ_DEP=${SEQ_LST[ $((seq_pnt + 4)) ]}
  SEQ_FILE="${SEQ_DIR}/${SEQ_STR}/${SEQ_STR}"

  # log
  echo ""
  echo "processing $SEQ_FILE ..."

  # time
  time_bgn_cur=$(date +%s)

  # for qp
  qp_pnt=0
  qp_lst_len=${#QP_LST[*]}
  while [ $qp_pnt -lt $qp_lst_len ]
  do
    # parameter
    QP_VAL=${QP_LST[ $((qp_pnt + 0)) ]}
    BIN_FILE="${RLT_DIR}/${SEQ_STR}_${SEQ_WID}x${SEQ_HEI}_${SEQ_FPS}_${QP_VAL}"

    # log
    echo "    qp $QP_VAL launched ..."

    # core
    ../../bin/hevc_testenc_vc8000e                                    \
      -i                            "${SEQ_FILE}.yuv"         \
      -o                            "${BIN_FILE}.hevc"        \
      -w                            ${SEQ_WID}                \
      -h                            ${SEQ_HEI}                \
      -b                            $((FRAME_LEN-1))          \
      -q                            ${QP_VAL}                 \
      --gopSize                     1                         \
      --intraPicRate                1                         \
      --rdoLevel                    1                         \
      --byteStream                  1                         \
      --outReconFrame               0                         \
    >& "${BIN_FILE}.log" &

    # counter
    qp_pnt=$((qp_pnt + 1))
  done

  # time
  while [ $(jobs | wc -l) -ne 0 ]
  do
    time_end=$(date +%s)
    printf "    delta time: %d min %d s; run time: %d min %d s (jobs: %d)        \r"    \
      $(( (time_end-time_bgn_cur) / 60                            ))                    \
      $(( (time_end-time_bgn_cur) - (time_end-time_bgn_cur)/60*60 ))                    \
      $(( (time_end-time_bgn_all) / 60                            ))                    \
      $(( (time_end-time_bgn_all) - (time_end-time_bgn_all)/60*60 ))                    \
      $(jobs | wc -l)
    jobs > /dev/null    # I don't know why, but this line must be added
    sleep 1
  done

  # for qp
  qp_pnt=0
  qp_lst_len=${#QP_LST[*]}
  while [ $qp_pnt -lt $qp_lst_len ]
  do
    QP_VAL=${QP_LST[ $((qp_pnt + 0)) ]}
    qp_pnt=$((qp_pnt + 1))

    # parameter
    BIN_FILE="${RLT_DIR}/${SEQ_STR}_${SEQ_WID}x${SEQ_HEI}_${SEQ_FPS}_${QP_VAL}"

    # grep
    cat $BIN_FILE.log     \
      | perl -e 'while (<>) {
                   if (/kb\/s: ([\d\.]+)/) {
                     printf "%-15.2f ", $1
                   }
                   if (/Y:([\d\.]+) U:([\d\.]+) V:([\d\.]+)/) {
                     printf "%-9.4f %-9.4f %-9.4f    ", $1, $2, $3
                   }
                   if (/error/) {
                     printf "%-98s", ""
                   }
                 }'       \
    >> $RLT_DIR/$RLT_LOG
    echo $BIN_FILE >> $RLT_DIR/$RLT_LOG
  done

  # time
  printf "    delta time: %d min %d s; run time: %d min %d s                  \n"     \
    $(( (time_end-time_bgn_cur) / 60                            ))                    \
    $(( (time_end-time_bgn_cur) - (time_end-time_bgn_cur)/60*60 ))                    \
    $(( (time_end-time_bgn_all) / 60                            ))                    \
    $(( (time_end-time_bgn_all) - (time_end-time_bgn_all)/60*60 ))

  # counter
  seq_pnt=$((seq_pnt + 5))

  python3 extract_data_i.py
done
