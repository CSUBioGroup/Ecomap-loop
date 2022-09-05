#!/bin/bash
set -e

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


areapath=$datapath"/area/";
RAD21file=$datapath"/RAD21.bed";
SMC3file=$datapath"/SMC3.bed";
CTCFfile=$datapath"/CTCF.bed";
fafile=$datapath"/hg19.fa";
memefile=$datapath"/CTCF.meme";
RAD21path=$workpath"/RAD21/";
SMC3path=$workpath"/SMC3/";
fapath=$workpath"/fasta/";
fimopath=$workpath"/fimo/";
fimo2path=$workpath"/fimoout/";
CTCFpath=$workpath"/CTCF/";


if [ ! -e $RAD21path ]; then
  mkdir --parent $RAD21path;
fi
if [ ! -e $SMC3path ]; then
  mkdir --parent $SMC3path;
fi
if [ ! -e $pairpath ]; then
  mkdir --parent $pairpath;
fi
if [ ! -e $fapath ]; then
  mkdir --parent $fapath;
fi
if [ ! -e $fimopath ]; then
  mkdir --parent $fimopath;
fi
if [ ! -e $fimo2path ]; then
  mkdir --parent $fimo2path;
fi
if [ ! -e $CTCFpath ]; then
  mkdir --parent $CTCFpath;
fi


for i in tss enh
do
	bedtools getfasta -fi $fafile -bed $areapath"/${i}.bed" -fo $fapath"/${i}.fa";
	fimo --oc $fimopath"/${i}.out" $memefile $fapath"/${i}.fa";
	cat $fimopath"/${i}.out/fimo.gff" |  grep -v '^#' | awk 'BEGIN{OFS=FS="\t";chr="";plus=minus=0;}{if(chr!=$1 ) {if(chr!=""){print chr,plus,minus;plus=minus=0;} chr=$1; if($7=="+") plus=$6; else{minus=$6;}} else{if($7=="+" &&  plus<$6) plus=$6; else if($7=="-" &&  minus<$6) minus=$6;}}'| sed -e 's/:/\t/' | sed -e 's/-/\t/' > $fimo2path"/${i}.bed";
	bedtools coverage  -a $areapath"/${i}.bed" -b $RAD21file > $RAD21path"/${i}.txt";
	bedtools coverage  -a $areapath"/${i}.bed" -b $SMC3file > $SMC3path"/${i}.txt";
    bedtools coverage  -a $areapath"/${i}.bed" -b $CTCFfile > $CTCFpath"/${i}.txt";
    
    cat $fimo2path"/${i}.bed" | awk '{print $1 ":" $2 ":" $3 "\t" $4 "\t" $5;}' | sort -k1 > $fimo2path"/${i}_sorted.bed";
    cat $RAD21path"/${i}.txt" | awk '{print $1 ":" $2 ":" $3 "\t" $5;}' | sort -k1 >  $RAD21path"/${i}_sorted.bed";
    cat $SMC3path"/${i}.txt" | awk '{print $1 ":" $2 ":" $3 "\t" $5;}' | sort -k1 >  $SMC3path"/${i}_sorted.bed";
    cat $CTCFpath"/${i}.txt" | awk '{print $1 ":" $2 ":" $3 "\t" $5;}' | sort -k1 >  $CTCFpath"/${i}_sorted.bed";
done

