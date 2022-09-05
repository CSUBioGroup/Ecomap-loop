#!/bin/bash
set -e

codepath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
cd $codepath;

datapath="";
workpath="";
resultpath="";

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
    -r|--resultpath)
    resultpath="$1"
    shift
    ;;
    *)
            # unknown option
    ;;
esac
done

areapath=$datapath"/area/";
tssfile=$areapath"/tss.bed";
enhfile=$areapath"/enh.bed";
looppath=$workpath"/loop/";
compath=$workpath"/com/";
RAD21path=$workpath"/RAD21/";
SMC3path=$workpath"/SMC3/";
fimo2path=$workpath"/fimoout/";
CTCFpath=$workpath"/CTCF/";

if [ ! -e $compath ]; then
  mkdir --parent $compath;
fi



##################################
join -t $'\t'  -o 1.1 1.2 1.3  2.1 2.2 2.3  $tssfile $enhfile | awk '{print $1 ":" $2 ":" $3 "-" $4 ":" $5 ":" $6 ;}' | sort -k1 | join -t $'\t' -a 1 -o 1.1 2.2 2.3 -e '0.0' - $looppath"/tss_enh.bed" | sed -e 's/\-/\t/g' | awk 'BEGIN{OFS=FS="\t";}{print $1,$3,$2,$4,sqrt(($3)*($4));}' > $compath"/tss_enh_peak.txt";
join -t $'\t'  -o 1.1 1.2 1.3  2.1 2.2 2.3  $tssfile $tssfile | awk 'BEGIN{FS=OFS="\t"}{if($2<$5) print $1,$2,$3,$4,$5,$6;}' | sort -k1,1V -k2,2n -k3,3n -k4,4V -k5,5n -k6,6n | uniq | awk '{print $1 ":" $2 ":" $3 "-" $4 ":" $5 ":" $6 ;}' | sort -k1 | join -t $'\t' -a 1 -o 1.1 2.2 2.3 -e '0.0' - $looppath"/tss_tss.bed" | sed -e 's/\-/\t/g' | awk 'BEGIN{OFS=FS="\t";}{print $1,$3,$2,$4,sqrt(($3)*($4));}' > $compath"/tss_tss_peak.txt";
join -t $'\t'  -o 1.1 1.2 1.3  2.1 2.2 2.3  $enhfile $enhfile | awk 'BEGIN{FS=OFS="\t"}{if($2<$5) print $1,$2,$3,$4,$5,$6;}' | sort -k1,1V -k2,2n -k3,3n -k4,4V -k5,5n -k6,6n | uniq | awk '{print $1 ":" $2 ":" $3 "-" $4 ":" $5 ":" $6 ;}' | sort -k1 | join -t $'\t' -a 1 -o 1.1 2.2 2.3 -e '0.0' - $looppath"/enh_enh.bed" | sed -e 's/\-/\t/g' | awk 'BEGIN{OFS=FS="\t";}{print $1,$3,$2,$4,sqrt(($3)*($4));}' > $compath"/enh_enh_peak.txt";



cat $compath"/tss_enh_peak.txt" | join -t $'\t' -a 1 -o 1.1 1.2 2.2 2.3 1.3 1.4 1.5 -e '0.0' - $fimo2path"/tss_sorted.bed" | join -t $'\t' -a 1 -o 1.1 1.2 1.3 1.4 2.2 1.5 1.6 1.7 -e '0.0' - $CTCFpath"/tss_sorted.bed" | join -t $'\t' -a 1 -o 1.1 1.2 1.3 1.4 1.5 2.2 1.6 1.7 1.8 -e '0.0' - $RAD21path"/tss_sorted.bed" | join -t $'\t' -a 1 -o 1.1 1.2 1.3 1.4 1.5 1.6 2.2 1.7 1.8 1.9 -e '0.0' - $SMC3path"/tss_sorted.bed"  | sort -k8 | join -t $'\t' -a 1 -o 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.2 2.3 1.10  -e '0.0' -1 8 -2 1  - $fimo2path"/enh_sorted.bed" | join -t $'\t' -a 1 -o 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 1.10 1.11 2.2 1.12 -e '0.0' -1 8 -2 1  - $CTCFpath"/enh_sorted.bed" | join -t $'\t' -a 1 -o 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 1.10 1.11 1.12 2.2 1.13 -e '0.0' -1 8 -2 1  - $RAD21path"/enh_sorted.bed" | join -t $'\t' -a 1 -o 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 1.10 1.11 1.12 1.13 2.2 1.14  -e '0.0' -1 8 -2 1  - $SMC3path"/enh_sorted.bed"  > $compath"/tss_enh_all.txt";
cat $compath"/tss_enh_peak.txt" | join -t $'\t' -a 1 -o 1.1 1.2 2.2 2.3 1.3 1.4 1.5 -e '0.0' - $fimo2path"/tss_sorted.bed" | join -t $'\t' -a 1 -o 1.1 1.2 1.3 1.4 2.2 1.5 1.6 1.7 -e '0.0' - $CTCFpath"/tss_sorted.bed" | join -t $'\t' -a 1 -o 1.1 1.2 1.3 1.4 1.5 2.2 1.6 1.7 1.8 -e '0.0' - $RAD21path"/tss_sorted.bed" | join -t $'\t' -a 1 -o 1.1 1.2 1.3 1.4 1.5 1.6 2.2 1.7 1.8 1.9 -e '0.0' - $SMC3path"/tss_sorted.bed"  | sort -k8 | join -t $'\t' -a 1 -o 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.2 2.3 1.10  -e '0.0' -1 8 -2 1  - $fimo2path"/tss_sorted.bed" | join -t $'\t' -a 1 -o 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 1.10 1.11 2.2 1.12 -e '0.0' -1 8 -2 1  - $CTCFpath"/tss_sorted.bed" | join -t $'\t' -a 1 -o 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 1.10 1.11 1.12 2.2 1.13 -e '0.0' -1 8 -2 1  - $RAD21path"/tss_sorted.bed" | join -t $'\t' -a 1 -o 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 1.10 1.11 1.12 1.13 2.2 1.14  -e '0.0' -1 8 -2 1  - $SMC3path"/tss_sorted.bed"  > $compath"/tss_tss_all.txt";
cat $compath"/enh_enh_peak.txt" | join -t $'\t' -a 1 -o 1.1 1.2 2.2 2.3 1.3 1.4 1.5 -e '0.0' - $fimo2path"/enh_sorted.bed" | join -t $'\t' -a 1 -o 1.1 1.2 1.3 1.4 2.2 1.5 1.6 1.7 -e '0.0' - $CTCFpath"/enh_sorted.bed" | join -t $'\t' -a 1 -o 1.1 1.2 1.3 1.4 1.5 2.2 1.6 1.7 1.8 -e '0.0' - $RAD21path"/enh_sorted.bed" | join -t $'\t' -a 1 -o 1.1 1.2 1.3 1.4 1.5 1.6 2.2 1.7 1.8 1.9 -e '0.0' - $SMC3path"/enh_sorted.bed"  | sort -k8 | join -t $'\t' -a 1 -o 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.2 2.3 1.10  -e '0.0' -1 8 -2 1  - $fimo2path"/enh_sorted.bed" | join -t $'\t' -a 1 -o 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 1.10 1.11 2.2 1.12 -e '0.0' -1 8 -2 1  - $CTCFpath"/enh_sorted.bed" | join -t $'\t' -a 1 -o 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 1.10 1.11 1.12 2.2 1.13 -e '0.0' -1 8 -2 1  - $RAD21path"/enh_sorted.bed" | join -t $'\t' -a 1 -o 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 1.10 1.11 1.12 1.13 2.2 1.14  -e '0.0' -1 8 -2 1  - $SMC3path"/enh_sorted.bed"  > $compath"/enh_enh_all.txt";

cat $compath"/tss_enh_all.txt" |  sed -e 's/\:/\t/g' | awk '{if($2<$11)print $1":"$2":"$3"\t"$10":"$11":"$12"\t"0.7*sqrt(($5)*($15))+0.15*sqrt(($5)*($14))+0.15*sqrt(($6)*($15))+0.1*($7+$8+$9+$16+$17+$18)+$19;else{print $1":"$2":"$3"\t"$10":"$11":"$12"\t"0.7*sqrt(($6)*($14))+0.15*sqrt(($5)*($14))+0.15*sqrt(($6)*($15))+0.1*($7+$8+$9+$16+$17+$18)+$19;}}' | sort -k3nr | awk 'BEGIN{OFS=FS="\t"}{if($3>400) print $1,$2;}' |  sed -e 's/\:/\t/g' > $resultpath"/tss_enh.bed";
cat  $compath"/tss_tss_all.txt" | awk 'BEGIN{OFS=FS="\t"}{print $1,$8,0.7*sqrt(($3)*($11))+0.15*sqrt(($3)*($10))+0.15*sqrt(($4)*($11))+0.1*($5+$6+$7+$12+$13+$14)+$15;}' | sort -k3nr | awk 'BEGIN{OFS=FS="\t"}{if($3>400) print $1,$2;}' |  sed -e 's/\:/\t/g' > $resultpath"/tss_tss.bed";
cat  $compath"/enh_enh_all.txt" | awk 'BEGIN{OFS=FS="\t"}{print $1,$8,0.7*sqrt(($3)*($11))+0.15*sqrt(($3)*($10))+0.15*sqrt(($4)*($11))+0.1*($5+$6+$7+$12+$13+$14)+$15;}' | sort -k3nr | awk 'BEGIN{OFS=FS="\t"}{if($3>400) print $1,$2;}' |  sed -e 's/\:/\t/g' > $resultpath"/enh_enh.bed";


