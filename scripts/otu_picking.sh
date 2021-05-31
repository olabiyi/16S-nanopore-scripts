#! /bin/bash
#$ -S /bin/bash
#$ -q bioinfo.q
#$ -V
#$ -cwd
#$ -N otu_summarize
#$ -pe shared 72
#$ -M obadbotanist@yahoo.com

#activate the qiime 2 environment
source activate qiime2-2019.4

#open reference otu picking
qiime vsearch cluster-features-open-reference \
	--i-table 02.demultiplexing/derep_table.qza \
	--i-sequences 02.demultiplexing/derep_seqs.qza \
	--i-reference-sequences ../q2_database/silva_16s.qza \
	--o-clustered-table 03.otu_picking/table_97.qza \
	--o-clustered-sequences 03.otu_picking/rep-seqs_97.qza \
	--o-new-reference-sequences 03.otu_picking/new_ref-seqs_97.qza \
	--p-perc-identity 0.97 \
	--p-threads 72 \
	--p-strand 'both' \

#summarize otu_table
qiime feature-table summarize \
	--i-table 03.otu_picking/table_97.qza \
	--o-visualization 03.otu_picking/table_97.qzv
