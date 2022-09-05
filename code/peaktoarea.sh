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
 if [ "${items[0]}" = "areapath" ]; then
   areapath=${items[1]}
 elif [ "${items[0]}" = "peakpath" ]; then
   peakpath=${items[1]}
   elif [ "${items[0]}" = "peakareapath" ]; then
   peakareapath=${items[1]}
 fi
done < $arglistfile;

tssfile=$areapath"/tss.bed";
enhfile=$areapath"/enh.bed";
othfile=$areapath"/oth.bed";

cd $peakpath;
peakfiles=$(ls *.peak.bed);
for peakfile in $peakfiles; do
    peakareafile=${peakfile%.bed}".area.bed";
    areafile=$peakareapath"/peak_area.txt";
    peaktssfile=$peakareapath"/peak_tss.txt";
    peakenhfile=$peakareapath"/peak_enh.txt";
    peakothfile=$peakareapath"/peak_oth.txt";
    rmtssfile=$peakareapath"/rm_tss_peak.txt";
    rmenhfile=$peakareapath"/rm_enh_peak.txt";
    
    bedtools intersect -a $tssfile -b $peakfile -wa -wb > $areafile;
    awk -vi='tss' 'BEGIN{OFS=FS="\t";}{print $1,$2,$3,i,$8;}' $areafile | sort -k1,1V -k2,2n -k3,3n -k5,5n | awk -vi='tss' 'BEGIN{OFS=FS="\t";c=l=r=v="";}{if( c !=$1 || l != $2 || r != $3) {if(c!="") print c,l,r,i,v;} c=$1;l=$2;r=$3;v=$5;}' > $peaktssfile;
    cat $areafile | awk 'BEGIN{OFS=FS="\t";}{print $4,$5,$6;}' | bedtools subtract -a $peakfile -b - > $rmtssfile;
    
    if [ -s $rmtssfile ]; then
     bedtools intersect -a $enhfile -b $rmtssfile -wa -wb > $areafile;
    awk -vi='enh' 'BEGIN{OFS=FS="\t";}{print $1,$2,$3,i,$8;}' $areafile | sort -k1,1V -k2,2n -k3,3n -k5,5n | awk -vi='enh' 'BEGIN{OFS=FS="\t";c=l=r=v="";}{if( c !=$1 || l != $2 || r != $3) {if(c!="") print c,l,r,i,v;} c=$1;l=$2;r=$3;v=$5;}' > $peakenhfile;
    cat $areafile | awk 'BEGIN{OFS=FS="\t";}{print $4,$5,$6;}' | bedtools subtract -a $rmtssfile -b - > $rmenhfile;
    
    if [ -s $rmenhfile ]; then
       bedtools intersect -a $othfile -b $rmenhfile -wa -wb > $areafile;
    awk -vi='oth' 'BEGIN{OFS=FS="\t";}{print $1,$2,$3,i,$8;}' $areafile | sort -k1,1V -k2,2n -k3,3n -k5,5n | awk -vi='oth' 'BEGIN{OFS=FS="\t";c=l=r=v="";}{if( c !=$1 || l != $2 || r != $3) {if(c!="") print c,l,r,i,v;} c=$1;l=$2;r=$3;v=$5;}' > $peakothfile;

    cat $peaktssfile $peakenhfile $peakothfile > $peakareapath$peakareafile;

     else 
      cat $peaktssfile $peakenhfile > $peakareapath$peakareafile;
     fi

     else 
     cat $peaktssfile > $peakareapath$peakareafile;
     fi

done

#rm *.txt;

