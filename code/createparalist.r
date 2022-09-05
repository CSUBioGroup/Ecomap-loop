rm(list=ls())

library("R.matlab")

args = commandArgs(trailingOnly=T);

rmatrixfile = "";
areapath = "";
looppath = "";
tmppath = "";
hg19sizefile = "";
hg19dofile = "";
chr = "";

##### Extract argument values #####

for (i in 1:length(args))
{
  arg = args[i];
  if (grepl("-rmatrixfile=",arg)==T)
  {
    k = regexpr("-rmatrixfile=",arg);
    k1 = k[[1]] + attr(k,"match.length"); # parameter starting position
    k2 = nchar(arg); # parameter stoping position
    rmatrixfile = substr(arg,k1,k2);
  } else if (grepl("-area=",arg)==T)
  {
    k = regexpr("-area=",arg);
    k1 = k[[1]] + attr(k,"match.length"); # parameter starting position
    k2 = nchar(arg); # parameter stoping position
    areapath = substr(arg,k1,k2);
  } else if (grepl("-looppath=",arg)==T)
  {
    k = regexpr("-looppath=",arg);
    k1 = k[[1]] + attr(k,"match.length"); # parameter starting position
    k2 = nchar(arg); # parameter stoping position
    looppath = substr(arg,k1,k2);
  } else if (grepl("-tmppath=",arg)==T)
  {
    k = regexpr("-tmppath=",arg);
    k1 = k[[1]] + attr(k,"match.length"); # parameter starting position
    k2 = nchar(arg); # parameter stoping position
    tmppath = substr(arg,k1,k2);
  } else if (grepl("-hg19sizefile=",arg)==T)
  {
    k = regexpr("-hg19sizefile=",arg);
    k1 = k[[1]] + attr(k,"match.length"); # parameter starting position
    k2 = nchar(arg); # parameter stoping position
    hg19sizefile = substr(arg,k1,k2);
  } else if (grepl("-hg19dofile=",arg)==T)
  {
    k = regexpr("-hg19dofile=",arg);
    k1 = k[[1]] + attr(k,"match.length"); # parameter starting position
    k2 = nchar(arg); # parameter stoping position
    hg19dofile = substr(arg,k1,k2);
  } else if (grepl("-chr=",arg)==T)
  {
    k = regexpr("-chr=",arg);
    k1 = k[[1]] + attr(k,"match.length"); # parameter starting position
    k2 = nchar(arg); # parameter stoping position
    chr = substr(arg,k1,k2);
  } else if (grepl("-codepath=",arg)==T)
  {
    k = regexpr("-codepath=",arg);
    k1 = k[[1]] + attr(k,"match.length"); # parameter starting position
    k2 = nchar(arg); # parameter stoping position
    codepath = substr(arg,k1,k2);
  } else if (grepl("-arglistfile=",arg)==T)
  {
    k = regexpr("-arglistfile=",arg);
    k1 = k[[1]] + attr(k,"match.length"); # parameter starting position
    k2 = nchar(arg); # parameter stoping position
    arglistfile = substr(arg,k1,k2);
  }
}


##### validate arguments #####

ret = T;
if (rmatrixfile=="" || file.exists(rmatrixfile)==F)
{
  print("-f|--rmatrixfile is empty or does not exist!\n");
  ret = F;
} else if (areapath=="" || file.exists(areapath)==F)
{
  print("-h|--areapath is empty or does not exist!\n");
  ret = F;
} else if (looppath=="")
{
  print("-o|--looppath is empty!\n");
  ret = F;
} else if (tmppath=="")
{
  print("-w|--tmppath is empty!\n");
  ret = F;
} else if (chr=="")
{
  print("-c|--chr is empty!\n");
  ret = F;
} 

##### if the arguments are valid, output these arguments to a file #####

if (ret==T)
{
  if (is.na(file.info(tmppath)$isdir==T))
  {
    command = paste("mkdir --parent ",tmppath,sep="");
    system(command);
  }
  
  inputpath = paste(tmppath,"input/",sep="");
  if (is.na(file.info(inputpath)$isdir)==T)
  {
    command = paste("mkdir --parent ",inputpath,sep="");
    system(command);
  }
  
  mpcapath = paste(tmppath,"mpca/",sep="");
  if (is.na(file.info(mpcapath)$isdir)==T)
  {
    command = paste("mkdir --parent ",mpcapath,sep="");
    system(command);
  }
  
  bedgraphpath = paste(tmppath,"bedgraph/",sep="");
  if (is.na(file.info(bedgraphpath)$isdir)==T)
  {
    command = paste("mkdir --parent ",bedgraphpath,sep="");
    system(command);
  }
  
  peakpath = paste(tmppath,"peak/",sep="");
  if (is.na(file.info(peakpath)$isdir)==T)
  {
    command = paste("mkdir --parent ",peakpath,sep="");
    system(command);
  }
  
  peakareapath = paste(tmppath,"peakarea/",sep="");
  if (is.na(file.info(peakareapath)$isdir)==T)
  {
    command = paste("mkdir --parent ",peakareapath,sep="");
    system(command);
  }
  
  pairpath = paste(tmppath,"pair/",sep="");
  if (is.na(file.info(pairpath)$isdir)==T)
  {
    command = paste("mkdir --parent ",pairpath,sep="");
    system(command);
  }

  if (is.na(file.info(looppath)$isdir)==T)
  {
    command = paste("mkdir --parent ",looppath,sep="");
    system(command);
  }
  

  
  varnames = c("rmatrixfile","areapath","tmppath","inputpath","mpcapath","bedgraphpath","peakpath","peakareapath","pairpath","looppath","chr","hg19dofile","hg19sizefile","codepath");
  vals = c(rmatrixfile,areapath,tmppath,inputpath,mpcapath,bedgraphpath,peakpath,peakareapath,pairpath,looppath,chr,hg19dofile,hg19sizefile,codepath);
  arglist = list(varnames,vals);
  write.table(arglist,file=arglistfile,quote=F,row.names=F,col.names=F,sep="\t");
}

rm(list=ls())
