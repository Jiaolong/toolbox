#! /usr/bin/env bash
# color and formatting:
# http://misc.flogisoft.com/bash/tip_colors_and_formatting

set -x
set -e

rm -rf models_face/*
#echo -e "\e[38;5;82mRunning experiment \e[38;5;198m${exid}\e[0m"
    
matlab -nodisplay -r "matlabpool('open', 4);acfFaceDemo;exit;"
