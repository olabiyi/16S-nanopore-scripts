#! /bin/bash
#$ -S /bin/bash
#$ -q bioinfo.q
#$ -V
#$ -cwd
#$ -N alignment
#$ -pe shared 64
#$ -M obadbotanist@yahoo.com

source ~/.bashrc

[ -d minimap_alignments/ ] || mkdir minimap_alignments/

[ -d minimap_alignments/rma ] || mkdir minimap_alignments/rma

#cd minimap_alignments/

files=$(basename -a $(ls /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/*fasta))

files=($files)

for f in ${files[*]};do

	sample=$(echo $f |sed s/\.fasta//)

	if [ -e /gpfs0/biores/users/gilloro/home/ess/Biyi/hinuman_analysis/minimap_alignments/chimeric_rma/${sample}.rma ]; then

	echo "${sample}.rma already done. Am moving to the next sample"
	continue

	fi

	# run minimap

	#minimap2 -ax map-ont \
	#	/gpfs0/biores/users/gilloro/Biyi/databases/SILVA_132_QIIME_release/rep_set/rep_set_16S_only/99/silva_132_99_16S.fna \
	#	/gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/${f} > \
	#	/gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/minimap_alignments/chimeric_sam/${sample}.sam 
 # on my user name
 # minimap2 -ax map-ont \
 # /gpfs0/bioinfo/users/obayomi/databases/SILVA_128_QIIME_release/rep_set/rep_set_16S_only/99/99_otus_16S.fasta \
 # /gpfs0/bioinfo/users/obayomi/hinuman_analysis/16S_nanopore/trimmed_reads/fasta/non_chimeric/BC01.fasta > minimap_alignments/BC01.sam


	# convert sam to rma for megan
	sam2rma \
		-i /gpfs0/biores/users/gilloro/home/ess/Biyi/hinuman_analysis/minimap_alignments/chimeric_sam/${sample}.sam \
		-lg \
		-alg longReads \
		-s2t  /gpfs0/biores/users/gilloro/home/megan/SSURef_Nr99_132_tax_silva_to_NCBI_synonyms.map \
		-v \
		-o /gpfs0/biores/users/gilloro/home/ess/Biyi/hinuman_analysis/minimap_alignments/chimeric_rma/${sample}.rma 

done




