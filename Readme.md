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

## 2. Prepare data
Several example data are provided in "data" folder (https://drive.google.com/file/d/1TfEzXSkaYihvzeYtpzQ0sToCir9eQnEO/view?usp=sharing).

The data in bam folder is the CHIP-seq data of different cells in ".bam" format.

"H1.control.bam" is the control CHIP-seq of H1 cells.

"hg19.fa" is the the gene sequence file in hg19 version.

## 3. Run 
Run "main.bash" to predict tss-tss, tss-enh, enh-enh interactions in H1, TBL and MSCcells.
```
./main.bash
```
The result come out in the result folder.

## 4. Details
The "main.bash" mainly contains three steps.
1. Exact the motif feature in each tss fragment and enh fragment. 
2. Exact the peaks co-vary across cells and assays. 
3. Merge the information got in step one and step two, then obtain the preditions.
