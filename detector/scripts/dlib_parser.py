#! /usr/bin/env python
#--------------------------------------------------
# ULSEE-ACF-Detector
#
# Parse dlib annotation file
#
# Copyright (c) 2016
# Written by Jiaolong Xu
#--------------------------------------------------

import os

def parse_dlib_annotation(fname):
    """
    Parse annotation file

    INPUT:
        - fname: annotation file
    OUTPUT:
        - pos: list of positive examples
        - neg: list of negative examples
    """

    pos = []
    neg = []
    num_faces = 0
    num_ignored = 0
    if not os.path.isfile(fname):
        raise Exception("Invalid file: {:s}".format(fname))

    lines = []
    # read all lines
    with open(fname, 'rb') as xml_file:
        lines = xml_file.readlines()

    sample = {}
    for (i, line) in enumerate(lines):
        line = line.strip()
        if line.startswith('<image file'):
            img_file = line[13:-2]
            # print img_file
            sample = {}
            sample['img_file'] = img_file
            sample['bbs'] = []
            sample['bbs_ignored'] = []

        if line.startswith('</image>'):
            if len(sample['bbs']) > 0:
                pos.append(sample)
            elif len(sample['bbs_ignored']) == 0:
                neg.append(sample)

        if line.startswith('<box'):
            ss = line.split('\'')
            (x1, y1, w, h) = (int(ss[3]), int(ss[1]),\
                    int(ss[5]), int(ss[7]))
            # we discard ignored samples
            if line.find('ignore') <= 0 and w > 20 and h > 20:
                sample['bbs'].append((x1, y1, w, h))
                num_faces += 1
                # print sample['bbs'][-1]
            else:
                sample['bbs_ignored'].append((x1, y1, w, h))
                num_ignored += 1

    print 'number of faces: ', num_faces
    print 'number of ignored faces: ', num_ignored

    return (pos, neg)
