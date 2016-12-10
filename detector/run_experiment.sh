#! /usr/bin/env bash
# color and formatting:
# http://misc.flogisoft.com/bash/tip_colors_and_formatting

set -x
set -e

DATASET=WIDER

rm -rf models_face/*${DATASET}*

#echo -e "\e[38;5;82mtTraining ACF detector on \e[38;5;198m${DATASET\e[0m"
    
matlab -nodisplay -r "matlabpool('open', 4);acfFace${DATASET};exit;"
