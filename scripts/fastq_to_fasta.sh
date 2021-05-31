#! /bin/bash
#$ -S /bin/bash
#$ -q bioinfo.q
#$ -V
#$ -cwd
#$ -N fastq2fasta
#$ -pe shared 24

source $HOME/.bashrc

mkdir /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta
cd /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/

#for f in $(ls *.fastq)
#do
#file_name=$(echo $f |sed 's/fastq/fasta/g')
#grep -A 1 '^@' $f | grep -v '^--$' | sed  's/^@/>/g' > fasta/${file_name}
#done

/gpfs0/biores/users/gilloro/Biyi/microbiome_helper/run_fastq_to_fasta.pl --parallel 72 --out_dir fasta/ *.fastq
