#! /usr/bin/env python
#--------------------------------------------------
# ULSEE-ACF-Detector
#
# Copyright (c) 2016
# Written by Jiaolong Xu
#--------------------------------------------------
"""
Visualizing Caltech Ground Truth
"""

import os
from PIL import Image, ImageDraw
import matplotlib as plt
import sys

set_name = 'train'
db_path = os.path.join('..', '..', 'data', 'aflw', 'data')
set_path = os.path.join(db_path, set_name)

dir_im = os.path.join(set_path, 'pos')
dir_gt = os.path.join(set_path, 'posGt')

if len(sys.argv) > 1:
    idx = int(sys.argv[1])
else:
    idx = 0

name = 'I%05d' % idx
image_file_jpg = os.path.join(dir_im, name + '.jpg')
image_file_png = os.path.join(dir_im, name + '.png')

if os.path.exists(image_file_jpg):
    im = Image.open(image_file_jpg)
elif os.path.exists(image_file_png):
    im = Image.open(image_file_png)
else:
    raise Exception('Image file not exists')

gt_file = os.path.join(dir_gt, name + '.txt')

if not os.path.exists(gt_file):
    raise Exception('Ground truth file not exists')

lines = []
with open(gt_file, 'r') as f:
    lines = f.readlines()

lines = lines[1:]
draw = ImageDraw.Draw(im)
for line in lines:
    ss = line.strip().split(' ')
    x1 = int(ss[1])
    y1 = int(ss[2])
    x2 = x1 + int(ss[3]) - 1
    y2 = y1 + int(ss[4]) - 1
    draw.rectangle([x1, y1, x2, y2])

im.show()
