rm(list=ls())

library("snowfall")
library("R.matlab")

args = commandArgs(trailingOnly=T);
for (i in 1:length(args))
{
  arg = args[i];
  if (grepl("-arglistfile=",arg)==T)
  {
    k = regexpr("-arglistfile=",arg);
    k1 = k[[1]] + attr(k,"match.length"); # parameter starting position
    k2 = nchar(arg); # parameter stoping position
    arglistfile = substr(arg,k1,k2);
  }
}

if (file.exists(arglistfile)==T)
{
  paralist = read.table(arglistfile,sep="\t");
  varnames = as.character(paralist[[1]]);
  vals = as.character(paralist[[2]]);
  
  for (i in 1:length(varnames))
  {
    varname = varnames[i];
    val = vals[i];
    if (is.numeric(val)==T)
    {
      val = as.numeric(val);
      command = paste(varname,"=",val,sep="");
      eval(parse(text=command));
    } else {
      command = paste(varname,"=\"",val,"\"",sep="");
      eval(parse(text=command));
    }
  }
  
  
  rdatafiles = read.table(rmatrixfile,sep="\t");
  cellnames = rownames(rdatafiles);
  assaynames = colnames(rdatafiles);
  rmatrixfile = as.matrix(rdatafiles);
  
  chromsize = read.table(hg19sizefile,sep="\t");
  chrs = as.character(chromsize[[1]]);
  Ls = as.numeric(as.character(chromsize[[3]]));
  id = which(chrs==chr);
  L = Ls[id];
  
  M = length(cellnames);
  N = length(assaynames);
  space = array(0,dim=c(M,N,L));
  for (m in 1:M)
  {
    for (n in 1:N)
    {
      rdatafile = rdatafiles[m,n];
      load(rdatafile);
      space[m,n,] = cov[[chr]]$y;
    }
  }
  
  domain = read.table(hg19dofile,header=F,sep="\t",quote="");
  domain = domain[domain[[1]]==chr,];
  for (k in 1:length(domain[[1]]))
  {
    domainstart = round((domain[[2]][k]-1)/200);
    domainstop = round((domain[[3]][k]-1)/200);
    if (domainstop<=L)
    {
      X = space[,,domainstart:domainstop];
      datafile = paste(inputpath,"/input_",chr,"_",k,".mat",sep="");
      writeMat(datafile,cellnames=cellnames,assaynames=assaynames,chr=chr,start=domain[[2]][k],stop=domain[[3]][k],X=X);
    }
  }  
}

rm(list=ls())