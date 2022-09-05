rm(list=ls())

##### Generate a list of data file locations #####

args = commandArgs(trailingOnly=T);

rdatapath = "";
rmatrixfile = "";

for (i in 1:length(args))
{
  arg = args[i];
  if (grepl("-midpath=",arg)==T)
  {
    k = regexpr("-midpath=",arg);
    k1 = k[[1]] + attr(k,"match.length"); # parameter starting position
    k2 = nchar(arg); # parameter stoping position
    rdatapath = substr(arg,k1,k2);
  } else if (grepl("-rmatrixfile=",arg)==T)
  {
    k = regexpr("-rmatrixfile=",arg);
    k1 = k[[1]] + attr(k,"match.length"); # parameter starting position
    k2 = nchar(arg); # parameter stoping position
    rmatrixfile = substr(arg,k1,k2);
  }
}

cells = c("H1","H1_BMP4_Derived_Trophoblast_Cultured_Cells","H1_Derived_Mesenchymal_Stem_Cells");
seqs = c("H3K27me3","H3K27ac","H3K36me3","H3K4me1","H3K4me3");

M = length(cells);
N = length(seqs);
rdatamatrix = matrix("",M,N);
rownames(datamatrix) = cells;
colnames(datamatrix) = seqs;

for (m in 1:M)
{
  for (n in 1:N)
  {
    rdatafile = paste(cells[m],".",seqs[n],".RData",sep="");
    rdatamatrix[m,n] = paste(rdatapath,rdatafile,sep="");
  }
}

write.table(rdatamatrix,file=rmatrixfile,quote=F,sep="\t",row.names=T,col.names=T);

rm(list=ls())
