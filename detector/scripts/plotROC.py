#! /usr/bin/env python
from matplotlib import pyplot as plt
import numpy as np
import os

def load_roc_data(fname, max_num_fp = 400):

    lines = []
    with open(fname, 'r') as f:
        lines = f.readlines()

    y = []
    x = []
    for line in lines:
        ss = line.strip().split(' ')
        y.append(ss[0])
        x.append(ss[1])

    x = np.array(x).astype(np.float32)
    y = np.array(y).astype(np.float32)
    idx = np.where(x <= max_num_fp)

    return (x[idx], y[idx])


name = 'detections-VJ'
fname = os.path.join(name, name+'DiscROC.txt')
(x0, y0) = load_roc_data(fname)

name = 'detections-Face-ACF-AFLW'
fname = os.path.join(name, name+'DiscROC.txt')
(x1, y1) = load_roc_data(fname)

name = 'detections-Face-ACF-DLIB-TRAIN'
fname = os.path.join(name, name+'DiscROC.txt')
(x2, y2) = load_roc_data(fname)

name = 'detections-dlib'
fname = os.path.join(name, name+'DiscROC.txt')
(x3, y3) = load_roc_data(fname)

name = 'detections-seeta'
fname = os.path.join(name, name+'DiscROC.txt')
(x4, y4) = load_roc_data(fname)


name = 'detections-acf-multiview'
fname = os.path.join(name, name+'DiscROC.txt')
(x5, y5) = load_roc_data(fname)

name = 'detections-ACF-CPP'
fname = os.path.join(name, name+'DiscROC.txt')
(x6, y6) = load_roc_data(fname)

with plt.style.context('fivethirtyeight'):
    plt.title('ROC curve on FDDB')
    plt.plot(x0, y0, 'b--', label='opencv3.0')
    plt.plot(x1, y1, 'b', label='ACF-AFLW')
    plt.plot(x2, y2, 'r', label='ACF-Dlib-Train')
    plt.plot(x3, y3, 'g', label='dlib-frontal-face')
    plt.plot(x4, y4, 'c', label='seeta')
    plt.plot(x5, y5, 'y', label='ACF-Multiview')
    plt.plot(x6, y6, 'r--', label='ACF-CPP')
    plt.xlabel('number of false positives')
    plt.ylabel('true positive rate')
    legend = plt.legend(loc='lower right', shadow=True, fontsize='x-large')
plt.show()
