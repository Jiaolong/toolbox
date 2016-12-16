#! /usr/bin/env python
#--------------------------------------------------
# ULSEE-ACF-Detector
#
# Copyright (c) 2016
# Written by Jiaolong Xu
#--------------------------------------------------
"""
Create AFLW train/test data for ACF detector
The data is organized in Caltech Pedestrian
Benchmark format.

The folders are as following:
    train/
        pos/
        neg/
        posGt/
    test/
        pos/

where 'pos' and 'neg' contains positive and negative images
'posGt' contains the ground truth. The ground truth in Caltech
Pedestrian Benchmark format:

    % bbGt version=3
    face x1 y1 w h 0 0 0 0 0 0 0
    face x1 y1 w h 0 0 0 0 0 0 0
"""
import shutil
import os
from aflw_parser import parse_aflw

db_path = os.path.join('..', '..', 'data', 'aflw', 'data')
db_file = os.path.join(db_path, 'aflw.sqlite')

pos, neg = parse_aflw(db_file, max_num_files=300, folder='0')

set_name = 'train'
set_path = os.path.join(db_path, set_name)

if os.path.exists(set_path):
    shutil.rmtree(set_path)

os.makedirs(os.path.join(set_path, 'pos'))
os.makedirs(os.path.join(set_path, 'posGt'))
os.makedirs(os.path.join(set_path, 'neg'))

idx = 0
for (i, p) in enumerate(pos):
    img_file = p['image_file']
    _, im_name = os.path.split(img_file)
    _, ext     = os.path.splitext(im_name)
    name_dst   = 'I%05d' % idx
    im_name_dst = name_dst + ext
    gt_name_dst = name_dst + '.txt'

    im_file_dst = os.path.join(set_path, 'pos',   im_name_dst)
    gt_file_dst = os.path.join(set_path, 'posGt', gt_name_dst)

    # write bbs into annotation file
    bbs = p['bbs']
    wm  = p['width']
    hm  = p['height']
    bbs_good = []

    for (x, y, w, h) in bbs:
        x = max(x, 1.0)
        y = max(y, 1.0)
        x = min(x, wm)
        y = min(y, hm)
        w  = min(wm-x, w)
        h  = min(hm-y, h)

        if not (w > 10 and h > 10):
            print 'too small: w=%f, h=%f' % (w, h)
            continue

        bbs_good.append([x,y, w, h])

    if len(bbs_good) == 0:
        continue

    with open(gt_file_dst, 'wb') as f:
        f.write('% bbGt version=3\n')
        for (x, y, w, h) in bbs_good:
            f.write('face %d %d %d %d 0 0 0 0 0 0 0\n' %\
                    (x, y, w, h))

    # copy file
    shutil.copyfile(os.path.join(db_path, img_file), im_file_dst)
    idx += 1

print 'created aflw dataset!'
