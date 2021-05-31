#! /bin/bash
#$ -S /bin/bash
#$ -q bioinfo.q
#$ -V
#$ -cwd
#$ -N run_centifuge
#$ -pe shared 72


# Download NCBI non-redundant database - takes about an hour to complete
#wget ftp://ftp.ncbi.nih.gov/blast/db/FASTA/nt.gz && gunzip nt.gz && mv -v nt nt.fa

# Get mapping file
#wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/gi_taxid_nucl.dmp.gz && gunzip -c gi_taxid_nucl.dmp.gz | sed 's/^/gi|/' > gi_taxid_nucl.map

#download NCBI taxonomy to the current directory
#centrifuge-download -o taxonomy taxonomy

#download archea, bacteria and viral genomes from NCBI's Refseq database
#centrifuge-download -o library -m -d "archaea,bacteria,viral" refseq > seqid2taxid.map

#To build the index, first concatenate all downloaded sequences into a single file
#cat library/*/*.fna > input-sequences.fna

#build index index for bacteria, archaea and viral genomes
#centrifuge-build -p 72 --conversion-table seqid2taxid.map \
#                     --taxonomy-tree taxonomy/nodes.dmp --name-table taxonomy/names.dmp \
#                     input-sequences.fna abv

# build non-redundant NCBI database index using 72 cores and a small bucket size, which will require less memory
#centrifuge-build -p 72 --bmax 1342177280 --conversion-table seqid2taxid.map \
#                  --taxonomy-tree taxonomy/nodes.dmp --name-table taxonomy/names.dmp \
#                  nt.fa nt

#build 16S rRNA refseq index
#centrifuge-build -p 72 --bmax 1342177280 --conversion-table seqid2taxid.map \
#                  --taxonomy-tree taxonomy/nodes.dmp --name-table taxonomy/names.dmp \
#                  bacteria.16SrRNA.fna refseq16S


#test run
mkdir  ../04.taxonomy/BC01_taxonomy/
centrifuge -f --met-file ../04.taxonomy/BC01_taxonomy/BC01_met_file.txt --threads 72 -x abv  --report-file  ../04.taxonomy/BC01_taxonomy/BC01_report.tsv -S  ../04.taxonomy/BC01_taxonomy/BC01_classification.txt ../trimmed_reads/fasta/non_chimeric/BC01_reduced_filtered.fasta


#CENTRIFUGE_HOME="/gpfs0/biores/users/gilloro/Biyi/centrifuge-centrifuge-genome-research/"


#files=$(ls /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/non_chimeric/*fasta |sed 's/\/gpfs0\/biores\/users\/gilloro\/Biyi\/hinuman_analysis\/trimmed_reads\/fasta\/non_chimeric\///g')
#files=($files)

#rm -rf ${analysis_dir}/filtered_centrifuge/${sample}_taxonomy || mkdir /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/filtered_centrifuge

#analysis_dir=/gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/

#for f in ${files[*]}
#do
#sample=$(echo $f |sed s/_reduced_filtered\.fasta//)
#assign taxonomy with centrifuge
####${analysis_dir}/filtered_centrifuge/${sample}_taxonomy 

####$CENTRIFUGE_HOME/centrifuge -f -x test ${analysis_dir}/trimmed_reads/fasta/non_chimeric/${f} 
#done
