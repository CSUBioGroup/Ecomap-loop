#!/bin/bash
set -e

mainpath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
cd $mainpath;

datapath=$mainpath"/data/";
codepath=$mainpath"/code/";
workpath=$mainpath"/tmp/";
resultpath=$mainpath"/result/";

if [ ! -e $workpath ]; then
  mkdir --parent $workpath;
fi
if [ ! -e $resultpath ]; then
  mkdir --parent $resultpath;
fi

$codepath"/step1.sh" -d $datapath -w $workpath;
$codepath"/step2.sh" -d $datapath -w $workpath;
$codepath"/step3.sh" -d $datapath -w $workpath -r $resultpath;

rm -r $workpath;
