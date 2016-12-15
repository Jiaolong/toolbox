#! /usr/bin/env python
import os
import shutil

list_file = os.path.join('ImageSets', 'Main', 'person_trainval.txt')

lines = []
with open(list_file, 'r') as f:
    lines = f.readlines()

count = 0
for (i,line) in enumerate(lines):
    ss = line.strip().split(' ')
    if ss[1] == '-1':
        img_file = os.path.join('JPEGImages', ss[0]+'.jpg')
        img_file_dst = os.path.join('..',
                'dlib_face_detection_dataset',
                'train', 'neg', ss[0]+'.jpg')
        shutil.copyfile(img_file, img_file_dst)
        count += 1

    if (i % 100) == 0:
        print '[%d/%d]' % (i+1, len(lines))

print 'Copied %d negative images' % count
