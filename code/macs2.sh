#!/bin/bash

while [[ $# > 1 ]]
do
key="$1"
shift

case $key in
    -a|--arglistfile)
    arglistfile="$1"
    shift
    ;;
     *)
            # unknown option
    ;;
esac
done

# parse arglistfile

while IFS=$'\t' read -r -a items
do
 if [ "${items[0]}" = "bedgraphpath" ]; then
   bedgraphpath=${items[1]}
 elif [ "${items[0]}" = "peakpath" ]; then
   peakpath=${items[1]}
 fi
done < $arglistfile;

cd $bedgraphpath;
tfiles=$(ls *.bedgraph | grep -v "bkgd");

for tfile in $tfiles; do
 echo $tfile;
 cfile=${tfile%.bedgraph}".bkgd.bedgraph";
 peakfile=${tfile%.bedgraph}".peak.bed";
 if [ ! -f $peakpath$peakfile ]; then
  macs2 bdgcmp -t $bedgraphpath$tfile -c $bedgraphpath$cfile -m ppois -o $peakpath"pvalue1.bedgraph";
  macs2 bdgpeakcall -i $peakpath"pvalue1.bedgraph" -c 10 -o $peakpath"peak.bed";
  awk '{if (NR>1) print $1 "\t" $2 "\t" $3 "\t" 0 "\t" $5}' $peakpath"peak.bed" > $peakpath$peakfile;
  rm $peakpath"pvalue1.bedgraph";
  rm $peakpath"peak.bed";
 fi
done