#! /usr/bin/env python
"""
Create train/test data for ACF detector
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

import os
import shutil
import cv2
from dlib_parser import parse_dlib_annotation

annotation_file = 'faces_2016_09_30.xml'

(pos, neg) = parse_dlib_annotation(annotation_file)
print 'number of pos: ', len(pos)
print 'number of neg: ', len(neg)

set_name = 'train'

if os.path.exists(set_name):
    shutil.rmtree(os.path.join('.', set_name))

os.makedirs(os.path.join(set_name, 'pos'))
os.makedirs(os.path.join(set_name, 'posGt'))
os.makedirs(os.path.join(set_name, 'neg'))

idx = 0
for (i, p) in enumerate(pos):
    #if i >= int(len(pos)):
    # if i >= 1000:
    #    break

    if i % 100 == 0:
        print '[pos]: %d/%d' % (i, len(pos))

    img_file = p['img_file']
    _, img_name_s = os.path.split(img_file)
    _, ext = os.path.splitext(img_name_s)
    name_t = 'I%05d' % idx
    img_name_t = name_t + ext
    gt_name_t  = name_t + '.txt'
    img_file_t = os.path.join(set_name, 'pos', img_name_t)
    gt_file_t = os.path.join(set_name, 'posGt', gt_name_t)
    # write bbs into annotation file
    bbs = p['bbs']
    assert(len(bbs) > 0)
    im = cv2.imread(img_file)
    wm = im.shape[1]
    hm = im.shape[0]
    bbs_good = []
    for (x1, y1, w ,h) in bbs:
        x1 = max(x1, 1.0)
        y1 = max(y1, 1.0)
        x1 = min(x1, wm)
        y1 = min(y1, hm)
        w = min(wm-x1, w)
        h = min(hm-y1, h)
        if not (w > 10 and h > 10):
            print 'too small: w=%f, h=%f' % (w, h)
            continue
        bbs_good.append([x1, y1, w, h])

    if len(bbs_good) == 0:
        continue

    with open(gt_file_t, 'wb') as f:
        f.write('% bbGt version=3\n')
        for (x1, y1, w ,h) in bbs_good:
            f.write('face %d %d %d %d 0 0 0 0 0 0 0\n' %\
                    (x1, y1, w, h))
    # copy file
    shutil.copyfile(img_file, img_file_t)
    idx += 1

for (i, n) in enumerate(neg):

    if i % 100 == 0:
        print '[neg]: %d/%d' % (i, len(pos))
    img_file = n['img_file']
    _, img_name_s = os.path.split(img_file)
    _, ext = os.path.splitext(img_name_s)
    name_t = 'I%05d' % i
    img_name_t = name_t + ext
    img_file_t = os.path.join(set_name, 'neg', img_name_t)
    # copy file
    shutil.copyfile(img_file, img_file_t)

print 'done!'
