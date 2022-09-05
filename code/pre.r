rm(list=ls())

library('spp')
# library('R.matlab')

options(warn=-1)

args = commandArgs(trailingOnly=T);


bammatrixfile = "";
controlfile = "";
rdatapath = "";
rmatrixfile = "";
hg19sizefile = "";


##### Extract argument values #####

for (i in 1:length(args))
{
  arg = args[i];
  if (grepl("-bammatrixfile=",arg)==T)
  {
    k = regexpr("-bammatrixfile=",arg);
    k1 = k[[1]] + attr(k,"match.length"); # parameter starting position
    k2 = nchar(arg); # parameter stoping position
    bammatrixfile = substr(arg,k1,k2);
  } else if (grepl("-controlfile=",arg)==T)
  {
    k = regexpr("-controlfile=",arg);
    k1 = k[[1]] + attr(k,"match.length"); # parameter starting position
    k2 = nchar(arg); # parameter stoping position
    controlfile = substr(arg,k1,k2);
  } else if (grepl("-rdatapath=",arg)==T)
  {
    k = regexpr("-rdatapath=",arg);
    k1 = k[[1]] + attr(k,"match.length"); # parameter starting position
    k2 = nchar(arg); # parameter stoping position
    rdatapath = substr(arg,k1,k2);
  } else if (grepl("-rmatrixfile=",arg)==T)
  {
    k = regexpr("-rmatrixfile=",arg);
    k1 = k[[1]] + attr(k,"match.length"); # parameter starting position
    k2 = nchar(arg); # parameter stoping position
    rmatrixfile = substr(arg,k1,k2);
  } else if (grepl("-hg19sizefile=",arg)==T)
  {
    k = regexpr("-hg19sizefile=",arg);
    k1 = k[[1]] + attr(k,"match.length"); # parameter starting position
    k2 = nchar(arg); # parameter stoping position
    hg19sizefile = substr(arg,k1,k2);
  } 
}
#########################
bammatrixfile = read.table(bammatrixfile,sep="\t");
cellnames = rownames(bammatrixfile);
assaynames = colnames(bammatrixfile);
bammatrixfile = as.matrix(bammatrixfile);

chrs = read.table(hg19sizefile,header=F,sep="\t",quote="");
chrname = as.character(chrs[[1]]);
chrsize = as.numeric(as.character(chrs[[2]]));

binsize =200;
M = length(cellnames);
N = length(assaynames);

rdatamatrix = matrix("",M,N);
rownames(rdatamatrix) = cellnames;
colnames(rdatamatrix) = assaynames;

for (m in 1:M)
{
    for (n in 1:N)
    {
      bamfile = bammatrixfile[m,n];
      mid.tags = read.bam.tags(bamfile);
      mid.tags = mid.tags$tags;
      mid.tags = remove.local.tag.anomalies(mid.tags);
      if (sum(sapply(mid.tags, is.null))>0) {
          mid.tags = mid.tags[-which(sapply(mid.tags, is.null))];
        }


      if(controlfile!="")
      {
        bkgd.tags = read.bam.tags(controlfile);
        bkgd.tags = bkgd.tags$tags;
        bkgd.tags = remove.local.tag.anomalies(bkgd.tags);
        cov = get.smoothed.tag.density(mid.tags,control.tags=bkgd.tags,bandwidth=binsize,step=binsize,tag.shift=0);
      } else if (controlfile=="")
      {
        cov = get.smoothed.tag.density(mid.tags,bandwidth=binsize,step=binsize,tag.shift=0);
      }

      cov = cov[names(cov)%in%chrname];

      seq_depth = 0;
      cov_norm = vector(mode="list",length(cov));

      for (j in 1:length(cov))
      {

        x1 = cov[[j]]$x;
        y1 = cov[[j]]$y;

        chr1 = which(names(cov[j])==chrname);

        xout1 = seq(1,chrsize[chr1],by=binsize);
        yout1 = approx(x1,y1,xout1,yleft=0,yright=0);
        yout1$y[yout1$y<0] = 0;

        cov_norm1 = data.frame(x=yout1$x,y=yout1$y);
        cov_norm1 = list(cov_norm1);

        cov_norm[j] = cov_norm1;
        names(cov_norm)[j] = chrname[chr1];
        seq_depth = seq_depth + sum(yout1$y);
      }

      for (j in 1:length(cov_norm))
      {
        cov_norm[[j]]$y = cov_norm[[j]]$y / seq_depth * sum(chrsize) / 100;
      }

    cov = cov_norm;
    rdatafile = paste(cellnames[m],".",assaynames[n],".RData",sep="");
    save(cov,file=paste(rdatapath,rdatafile,sep=""));
    
    rdatamatrix[m,n] = paste(rdatapath,rdatafile,sep="");
    }
}

write.table(rdatamatrix,file=rmatrixfile,quote=F,sep="\t",row.names=T,col.names=T);

rm(list=ls())