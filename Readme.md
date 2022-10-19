# Ecomap-loop
## 1. Environment (64-bit LINUX distribution):
- Download MATLAB Compiler Runtime (MCR, http://www.mathworks.com/supportfiles/MCR_Runtime/R2013a/MCR_R2013a_glnxa64_installer.zip)
    ```
    ./install
    ```
    Alternatively, you can install MCR non-interactively using the following commands:
    ```
    ./install -mode silent -agreeToLicense yes -destinationFolder <MCRROOT>
    ```
    where \<MCRROOT\> is the root directory of MCR .
    
    When the installation is done, add the following line to your ".bashrc" file:
    ```
    export MCRROOT=<MCRROOT>
    ```
- R enviroment (http://www.r-project.org/): "R.matlab","snowfall" and "spp" packages should be installed.
- Download wigToBigWig (http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/). Only wigToBigWig is needed.
- Download MACS2 software (https://github.com/taoliu/MACS/wiki/Install-macs2) and follow the instructions to install it.
- Download BEDTools(https://bedtools.readthedocs.io/en/latest/index.html).
- Download the meme suit (https://meme-suite.org/meme/doc/download.html).
- Download python packages: pandas, numpy, os and argparse.

## 2. Prepare data
Several example data are provided in "data" folder (https://zenodo.org/record/7220553#.Y06V29dByUk).

The data in bam folder is the CHIP-seq data of different cells in ".bam" format.

"H1.control.bam" is the control CHIP-seq of H1 cells.

"hg19.fa" is the the gene sequence file in hg19 version.

The "area" folder includes tss, enhancer and other region divided in the whole genome.

"CTCF.bed", "RAD21.bed" and "SMC3.bed" are the CTCF CHIP-seq data, RAD21 CHIP-seq data and SMC3 CHIP-seq data for the H1 cell line, respectively.

"CTCF.meme" is the location information of DNA sequence combined with CTCF, downloaded in JASPAR(https://jaspar.genereg.net/matrix/MA0139.1/).

## 3. Run 
Run "main.bash" to predict tss-tss, tss-enh, enh-enh interactions in H1, TBL and MSCcells.
```
./main.bash
```
The result come out in the result folder.

## 4. Details
The "main.bash" mainly contains three steps.
1. "step1.sh": Exact the motif (including CTCF,RAD21 and SMC3) feature in each tss fragment and enh fragment.
2. "step2.sh": Exact the peaks co-vary across cells and assays.
3. "step3.sh": Merge the information got in step one and step two, then obtain the preditions.

