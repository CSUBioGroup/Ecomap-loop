#!/bin/bash

codepath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
cd $codepath;

datapath="";
workpath="";

while [[ $# > 1 ]]
do
key="$1"
shift

case $key in
    -d|--datapath)
    datapath="$1"
    shift
    ;;
    -w|--workpath)
    workpath="$1"
    shift
    ;;
    *)
            # unknown option
    ;;
esac
done

chr="chr1";
areapath=$datapath"/area/";
bampath=$datapath"/bam/";
controlfile=$datapath"/H1.control.bam";
hg19sizefile=$datapath"/hg19chromsize.txt";
hg19dofile=$datapath"/hg19domain.bed";
bammatrixfile=$workpath"/bammatrix.txt";
rdatapath=$workpath"/rdata/";
rmatrixfile=$workpath"/rdatamatrix.txt";
looppath=$workpath"/loop/";

if [ ! -e $rdatapath ]; then
  mkdir --parent $rdatapath;
fi
if [ ! -e $looppath ]; then
  mkdir --parent $looppath;
fi

Rscript "createbamMatrixFile.r" -bampath=$bampath -bammatrixfile=$bammatrixfile;
Rscript "pre.r" -bammatrixfile=$bammatrixfile -controlfile=$controlfile -rdatapath=$rdatapath -rmatrixfile=$rmatrixfile -hg19sizefile=$hg19sizefile;

$codepath"/exloops.bash" -f $rmatrixfile -h $areapath -w $workpath -l $looppath -a $hg19sizefile -b $hg19dofile -c $chr;


