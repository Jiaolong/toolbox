#! /usr/bin/env python
#--------------------------------------------------
# ULSEE-ACF-Detector
#
# Copyright (c) 2016
# Written by Jiaolong Xu
#--------------------------------------------------
"""
This file parse AFLW annotations.
"""
import os
import sqlite3 as lite

def parse_aflw(db_file, max_num_files = 1e5, folder = 'all'):
    """
    Parse AFLW annotations.

    inputs:
        -db_file: sqlite database file
        -max_num_files: maximum number of files to read

    returns:
        -pos: positive examples with following fields
            .image_file: image file path
            .width: image width
            .height: image height
            .bbs: a list of bounding boxes, each with
                .x: left coordinate
                .y: top coordinate
                .w: width of the box
                .h: height of the box
    """

    pos = []
    neg = []
    num_faces = 0

    # try to connect to database
    try:
        con = lite.connect(db_file)
    except lite.Error, e:
        print 'Error: %s:' % e.args[0]
        return pos

    with con:
        cur = con.cursor()
        cur.execute("SELECT file_id FROM Faces")
        con.commit()

        row_fs = cur.fetchall()
        for (i, row_fid) in enumerate(row_fs):

            if len(pos) > max_num_files:
                break

            file_id = row_fid[0]

            if (i + 1) % 100 == 0:
                print '[%d/%d] %s' % (i+1, len(row_fs), file_id)

            # select db_id, filepath etc
            sql = "SELECT db_id,filepath,width,height FROM FaceImages WHERE file_id = \"{:s}\"".format(file_id)
            cur.execute(sql)
            con.commit()
            row_file = cur.fetchone()
            (db_id, filepath, width, height) = row_file[0:4]

            if folder != 'all' and not filepath.startswith(folder):
                continue

            sample = {}
            sample['image_file'] = os.path.join(db_id, filepath)
            sample['width']  = width
            sample['height'] = height
            sample['bbs']    = []

            # select faces
            sql = 'SELECT face_id FROM Faces WHERE file_id = \"{:s}\"'.format(file_id)
            cur.execute(sql)
            con.commit()
            row_faces = cur.fetchall()

            for row_face in row_faces:
                face_id = row_face[0]

                # select bboxes
                sql = 'SELECT x,y,w,h FROM FaceRect WHERE face_id = \"{:d}\"'.format(face_id)
                cur.execute(sql)
                con.commit()
                row_rec = cur.fetchone()

                if row_rec is not None:
                    (x, y, w, h) = row_rec[0:4]
                    sample['bbs'].append((x, y, w, h))
                    num_faces += 1

            if len(sample['bbs']) > 0:
                pos.append(sample)
            else:
                neg.append(sample)

    print 'number of faces: ', num_faces
    print 'number of positive samples: ', len(pos)
    print 'number of negative samples: ', len(neg)
    print 'parsing aflw done!'
    return (pos, neg)
