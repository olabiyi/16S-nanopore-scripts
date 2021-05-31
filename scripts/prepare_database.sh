#! /bin/bash
#$ -S /bin/bash
#$ -q bioinfo.q
#$ -V
#$ -cwd
#$ -N prepare_database
#$ -pe shared 72


#activate the qiime 2 environment
source activate qiime2-2019.4


#prepare your database
mkdir ../q2_database

# First import the database
qiime tools import \
  --type 'FeatureData[Sequence]' \
  --input-path /gpfs0/biores/users/gilloro/Biyi/SILVA_132_QIIME_release/rep_set/rep_set_16S_only/97/silva_132_97_16S.fna \
  --output-path ../q2_database/silva_16s.qza



#taxonomy

# Then import the taxonomy file
qiime tools import \
  --type 'FeatureData[Taxonomy]' \
  --input-format HeaderlessTSVTaxonomyFormat \
  --input-path /gpfs0/biores/users/gilloro/Biyi/SILVA_132_QIIME_release/taxonomy/16S_only/97/consensus_taxonomy_7_levels.txt \
  --output-path ../q2_database/silva_16s_tax.qza
  


# Finally train the classifier
qiime feature-classifier fit-classifier-naive-bayes \
  --i-reference-reads ../q2_database/silva_16s.qza \
  --i-reference-taxonomy ../q2_database/silva_16s_tax.qza \
  --o-classifier ../q2_database/silva_16s_classifier.qza

