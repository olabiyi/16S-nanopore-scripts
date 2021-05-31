#! /bin/bash
#$ -S /bin/bash
#$ -q bioinfo.q
#$ -V
#$ -cwd
#$ -N derep_seqs
#$ -pe shared 72


#activate the qiime 2 environment
source activate qiime2-2019.4


#dereplicate sequences
qiime vsearch dereplicate-sequences \
  --i-sequences 02.demultiplexing/seqs.qza \
  --o-dereplicated-table 02.demultiplexing/derep_table.qza \
  --o-dereplicated-sequences 02.demultiplexing/derep_seqs.qza
