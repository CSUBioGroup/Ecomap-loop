import pandas as pd
import numpy as np
import os
import argparse

def parse_args():
    description = "lambdas selection"
    parser = argparse.ArgumentParser(description=description)
    parser.add_argument("-f", "--arglist", type=str, help="arglistfile")
    return parser.parse_args()

def lambda_select(value, num, l, s, q):
    lambdas = [0.0]*num
    for i in range(num):
        if i%s == 0:
            left = max(0, i-l)
            right = min(num, i+l)
            temp = []
            flag = False
            for j in range(left, right):
                if val[j]>0:
                    temp.append(val[j])
                    flag = True
            if flag:
                temp.sort()
                endpos = int(min(len(temp)*q+0.5, len(temp)))
                lambdas[i] = max(sum(temp[:endpos])/endpos, 2)
            else:
                lambdas[i] = 2
        else:
            lambdas[i] = lambdas[i-1]
    return lambdas


if __name__ == '__main__':
    # arglistfile = './arglist.txt'
    args = parse_args()
    arglistfile = args.arglist

    val_path = {}
    with open(arglistfile, 'r') as f:
        content = f.readlines()
        for line in content:
            tp = line.strip().split()
            val_path[tp[0]] = tp[1]

    bedfiles = []
    files = os.listdir(val_path['bedgraphpath'])
    for file in files:
        filepath = os.path.join(val_path['bedgraphpath'], file)
        if ('.bedgraph' in file) and ('bkgd' not in file):
            bedfiles.append(filepath)

    for file in bedfiles:
        bkgdfile = file.replace('.bedgraph', '.bkgd.bedgraph')
        
        beddata = pd.read_table(file, header=None)
        chr = beddata[0].tolist()
        start = beddata[1].tolist()
        end = beddata[2].tolist()
        val = beddata[3].tolist()

        sample = beddata.shape[0]
        L, S, Q = 500, 250, 0.5
        lambdas = lambda_select(val, sample, L, S, Q)
        
        finaldata = pd.DataFrame({'chr':chr, 'start':start, 'end':end, 'val':lambdas})
        finaldata.to_csv(bkgdfile, index=False, header=None, sep='\t')