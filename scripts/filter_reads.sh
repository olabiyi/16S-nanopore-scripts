#! /bin/bash
#$ -S /bin/bash
#$ -q bioinfo.q
#$ -V
#$ -cwd
#$ -N filter_reads
#$ -pe shared 40


#activate the qiime 2 environment
source activate qiime2-2019.4


rm -rf trimmed_reads/
mkdir trimmed_reads/
cd reads/fastq/
for f in $(ls *.fastq)
do
#filter low quality nanopore reads
cat $f | NanoFilt --quality 9 --headcrop 50 --maxlength 1500 > ../../trimmed_reads/$f
done
