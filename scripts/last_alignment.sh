#! /bin/bash
#$ -S /bin/bash
#$ -q bioinfo.q
#$ -V
#$ -cwd
#$ -N LAST_alignment
#$ -pe shared 72
#$ -M obadbotanist@yahoo.com

#files=$(ls /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/non_chimeric/*fasta |sed 's/\/gpfs0\/biores\/users\/gilloro\/Biyi\/hinuman_analysis\/trimmed_reads\/fasta\/non_chimeric\///g')
#files=($files)

#[ -d /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/rdp_taxonomy ] || mkdir /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/rdp_taxonomy
#[ -d /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/blast_taxonomy ] || mkdir /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/blast_taxonomy


#for f in ${files[*]}
#do

#sample=$(echo $f |sed s/\.fasta//)


#done

#cd /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/rdp_taxonomy/
#cd /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/blast_taxonomy/

#mkdir together
#for dir in $(ls); do if [ $dir == together/ ]; then continue; fi; cp $dir/*txt together/; donei
source ~/.bashrc

[ -d last_alignments/ ] || mkdir last_alignments/

cd last_alignments/

# run LAST
# make database
#lastdb -cR01 silva /gpfs0/biores/users/gilloro/Biyi/databases/SILVA_132_QIIME_release/rep_set/rep_set_16S_only/99/silva_132_99_16S.fna 

# map silva agains sample the convert the resulting .maf file to a .sam file
#lastal -P72 silva /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/BC01.fasta | \
#	maf-convert sam > BC01.sam


# run MEGAN-LR pipeline for metagenomics
lastal -P72 silva /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/BC01.fasta | 
	sort-last-maf > BC01_sorted.maf
