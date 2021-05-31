#! /bin/bash
#$ -S /bin/bash
#$ -q bioinfo.q
#$ -V
#$ -cwd
#$ -N nanoClust_analysis
#$ -pe shared 64
#$ -M obadbotanist@yahoo.com


#This script will use the nanoClust.py software to cluster nanopore reads to OTUs



# Activate qiime2 because it as vsearch, biopython and mafft-ginsi required by nanoClust
source activate python2

# Do the commented code section before running this script at all
# get the python scripts needed by nanoclust
# wget https://drive5.com/python/python_scripts.tar.gz
# tar -xvzf python_scripts.tar.gz
# mkdir  ~/bin && mv *.py ~/bin && chmod +x ~/bin/*


# change to the hinoman analysis directory and make a directory 
# that will contain fasta file format in a way vsearch requires

#cd hinuman_analysis/
#mkdir -p nanoClust_analysis/vsearch_format_files


# get the sample names and the rename the header lines as required by vsearch
#samples=$(ls trimmed_reads/fasta/non_chimeric/ | sed 's/_reduced_filtered.fasta//g'| sort -u) && samples=($samples)

#for sample in ${samples[*]}; do
 
#awk -v k="$sample" '/^>/{gsub(">","",$0);$0=">barcodelabel="k";"$0}1' trimmed_reads/fasta/non_chimeric/${sample}_reduced_filtered.fasta > nanoClust_analysis/vsearch_format_files/${sample}_barcode.fa; 

#done

# combine the barcoded files in one fasta file
#cat nanoClust_analysis/vsearch_format_files/*_barcode.fa > nanoClust_analysis/vsearch_format_files/multiplexed.fa


/gpfs0/biores/users/gilloro/home/miniconda3/envs/python2/bin/python /gpfs0/biores/users/gilloro/Biyi/NanoAmpli-seq/nanoCLUST.py nanoClust_analysis/vsearch_format_files/multiplexed.fa
