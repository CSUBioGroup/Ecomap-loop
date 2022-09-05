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
    if [ "${items[0]}" = "peakareapath" ]; then
   peakareapath=${items[1]}
    elif [ "${items[0]}" = "pairpath" ]; then
   pairpath=${items[1]}
    elif [ "${items[0]}" = "tmppath" ]; then
   tmppath=${items[1]}
   elif [ "${items[0]}" = "looppath" ]; then
   looppath=${items[1]}
 fi
done < $arglistfile;

cd $peakareapath;
peakareafiles=$(ls *.peak.area.bed);
for peakareafile in $peakareafiles; do
     pairfile=${peakareafile%.peak.area.bed}".pair.area.bed";
    join -t $'\t'  -o 1.1 1.2 1.3 1.4 1.5 2.1 2.2 2.3 2.4 2.5  $peakareafile $peakareafile | awk 'BEGIN{FS=OFS="\t"}{if($2<$7) print $0;}' | sort -k1,1V -k2,2n -k3,3n -k6,6V -k7,7n -k8,8n | uniq >  $pairpath$pairfile;
done

allpairfile=$tmppath"/allpairs.bed";
finalfile=$tmppath"/finalpairs.bed";
cd $pairpath;
cat *.bed |  awk 'BEGIN{OFS=FS="\t";}{print $0,$5*$10}' | sort -k1,1V -k2,2n -k3,3n -k4,4 -k6,6V -k7,7n -k8,8n -k9,9 -k11,11n | uniq  > $allpairfile;
cat $allpairfile | awk 'BEGIN{OFS=FS="\t";c1=l1=r1=a1=v1=c2=l2=r2=a2=v2=v3="";}{if((c1==$1 && l1==$2 && r1==$3 && a1==$4 && c2==$6 && l2==$7 && r2==$8 && a2==$9 && $11>=v3)||c1=="") {c1=$1;l1=$2;r1=$3;a1=$4;v1=$5;c2=$6;l2=$7;r2=$8;a2=$9;v2=$10;v3=$11;}else{print $0;}}' > $finalfile;
rm $allpairfile;

cat $finalfile | awk '{if ($4~"tss" && $9~"tss") {if ($2<$7) print $1 ":" $2 ":" $3 "-" $6 ":" $7 ":" $8 "\t" $5 "\t" $10; else if ($2>$7) print $6 ":" $7 ":" $8 "-" $1 ":" $2 ":" $3 "\t" $10 "\t" $5}}'| sort -k1 | uniq > $looppath"/tss_tss.bed";
cat $finalfile | awk '{if ($4~"enh" && $9~"enh") {if ($2<$7) print $1 ":" $2 ":" $3 "-" $6 ":" $7 ":" $8 "\t" $5 "\t" $10; else if ($2>$7) print $6 ":" $7 ":" $8 "-" $1 ":" $2 ":" $3 "\t" $10 "\t" $5}}'| sort -k1 | uniq > $looppath"/enh_enh.bed";
cat $finalfile | awk '{if ($4~"tss" && $9~"enh") {print $1 ":" $2 ":" $3 "-" $6 ":" $7 ":" $8 "\t" $5 "\t" $10;} else if ($4~"enh" && $9~"tss") {print $6 ":" $7 ":" $8 "-" $1 ":" $2 ":" $3 "\t" $10 "\t" $5}}'| sort -k1 | uniq > $looppath"/tss_enh.bed";

