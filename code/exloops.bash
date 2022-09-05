#!/bin/bash

set -o errexit;

##### check for dependencies #####
command -v macs2 >/dev/null 2>&1 || { echo "macs2 not installed. Check here https://github.com/taoliu/MACS/wiki/Install-macs2 ... Aborting." >&2; exit 1; }

codepath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
cd $codepath;

rmatrixfile="";
areapath="";
workpath="";
looppath="";
hg19sizefile="";
hg19dofile="";
chr="";

while [[ $# > 1 ]]
do
key="$1"
shift

case $key in
    -f|--rmatrixfile)
    rmatrixfile="$1"
    shift
    ;;
    -h|--area)
    areapath="$1"
    shift
    ;;
    -w|--workpath)
    workpath="$1"
    shift
    ;;
    -l|--looppath)
    looppath="$1"
    shift
    ;;
    -a|--hg19sizefile)
    hg19sizefile="$1"
    shift
    ;;
    -b|--hg19dofile)
    hg19dofile="$1"
    shift
    ;;
    -c|--chr)
    chr="$1"
    shift
    ;;
    *)
            # unknown option
    ;;
esac
done

# validate arguments
tmppath=$workpath"/${chr}_tmp/";
arglistfile=$tmppath"/arglist.txt";


if [ -e $tmppath ]; then
  mkdir --parent $tmppath;
fi

Rscript "createparalist.r" -rmatrixfile=$rmatrixfile -area=$areapath -looppath=$looppath -tmppath=$tmppath -hg19sizefile=$hg19sizefile -hg19dofile=$hg19dofile -chr=$chr -codepath=$codepath -arglistfile=$arglistfile;


if [ -e $arglistfile ]; then
  Rscript "process.r" -arglistfile=$arglistfile;
  $codepath"/decompose.bash"  $arglistfile;
  Rscript "reprocess.r" -arglistfile=$arglistfile;
  python "get_lambda.py" -f  $arglistfile;
  $codepath"/macs2.sh" -a $arglistfile;
  $codepath"/peaktoarea.sh" -a $arglistfile;
  $codepath"/peaktopair.sh" -a $arglistfile;

fi


#if [ -e $tmppath ]; then
# rm -r -f $tmppath;
#fi

