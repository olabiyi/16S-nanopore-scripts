#!/usr/bin/env bash


cd trimmed_reads/fasta/non_chimeric/
[ -d multiplexed/ ] || mkdir multiplexed/

files=$(ls *.fasta) 
files=($files)


for file in ${files[*]}; do


sample=$(echo $file| sed -e 's/\.fasta//g')

# rename the header lines to containg the sample sample
awk -v sample="$sample" -v count=1 '/^>/ {gsub(">","",$0);$0=">"sample"_"count" "$0; count++}1' $file > multiplexed/${sample}.fasta

done

cat multiplexed/*.fasta > multiplexed/seqs.fna

rm -rf multiplexed/*.fasta
