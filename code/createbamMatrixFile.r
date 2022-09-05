rm(list=ls())

##### Generate a list of bam file locations #####

args = commandArgs(trailingOnly=T);

bampath = "";
bammatrixfile = "";

for (i in 1:length(args))
{
  arg = args[i];
  if (grepl("-bampath=",arg)==T)
  {
    k = regexpr("-bampath=",arg);
    k1 = k[[1]] + attr(k,"match.length"); # parameter starting position
    k2 = nchar(arg); # parameter stoping position
    bampath = substr(arg,k1,k2);
  } else if (grepl("-bammatrixfile=",arg)==T)
  {
    k = regexpr("-bammatrixfile=",arg);
    k1 = k[[1]] + attr(k,"match.length"); # parameter starting position
    k2 = nchar(arg); # parameter stoping position
    bammatrixfile = substr(arg,k1,k2);
  }
}

cellnames = c("H1","H1_BMP4_Derived_Trophoblast_Cultured_Cells","H1_Derived_Mesenchymal_Stem_Cells");
assaynames = c("H3K27me3","H3K27ac","H3K36me3","H3K4me1","H3K4me3");

M = length(cellnames);
N = length(assaynames);
bammatrix = matrix("",M,N);
rownames(bammatrix) = cellnames;
colnames(bammatrix) = assaynames;

for (m in 1:M)
{
  for (n in 1:N)
  {
    bamfile = paste(cellnames[m],".",assaynames[n],".bam",sep="");
    bammatrix[m,n] = paste(bampath,bamfile,sep="");
  }
}

write.table(bammatrix,file=bammatrixfile,quote=F,sep="\t",row.names=T,col.names=T);

rm(list=ls())

