#! /bin/bash
#$ -S /bin/bash
#$ -q bioinfo.q
#$ -V
#$ -cwd
#$ -N chimera_check
#$ -pe shared 72

# exit script when a error occurs
set -o errexit

# throw an error message when attempting to refer to an unset/undefined variable
set -o nounset 
#activate the qiime 2 environment
#source activate qiime2-2019.4

#check for chimera using vsearch based on a denovo approach after OTU clustering
#qiime vsearch uchime-denovo \
#  --i-table 03.otu_picking/table_97.qza \
#  --i-sequences 03.otu_picking/rep-seqs_97.qza \
#  --output-dir 03.otu_picking/uchime_denovo_dir
  
  
# Remove chimeric sequences from table
#qiime feature-table filter-features \
#	--i-table 03.otu_picking/table_97.qza \
#	--m-metadata-file  03.otu_picking/uchime_denovo_dir/nonchimeras.qza \
#	--o-filtered-table 03.otu_picking/table_dn_nc.qza

# Remove chimeric sequences from representative sequences
#qiime feature-table filter-seqs \
#	--i-data 03.otu_picking/rep-seqs_97.qza \
#	--m-metadata-file  03.otu_picking/uchime_denovo_dir/nonchimeras.qza \
#	--o-filtered-data 03.otu_picking/rep-seqs_dn_nc.qza

	
	
#Optionally to summarize chimera removal steps
#qiime feature-table summarize \
#	--i-table 03.otu_picking/table_dn_nc.qza \
#	--o-visualization 03.otu_picking/table_dn_nc.qzv



#remove singletons
#qiime feature-table filter-features \
#  --i-table 03.otu_picking/table_dn_nc.qza \
#  --p-min-frequency 2 \
#  --o-filtered-table 03.otu_picking/table_ns_dn_nc.qza


#Optionally to summarize singleton removal steps
#qiime feature-table summarize \
#	--i-table 03.otu_picking/table_ns_dn_nc.qza \
#	--o-visualization 03.otu_picking/table_ns_dn_nc.qzv 

#rm -rf /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/alignments

#mkdir /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/alignments

#cd /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/split_fasta

#when handling large files
#cd /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/large_fasta

#for f in $(ls *.fasta)
#do

#sample=$(echo $f |sed 's/.fasta//g')

#all against all read mapping
#minimap2 $f $f > ../fasta/alignments/${sample}_mapping.paf

#get the non-chimeric sequences 
#yacrd chimeric -i ../fasta/alignments/${sample}_mapping.paf -f $f 

#done

cd /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta
samples=$(ls *.fasta | sed -e 's/\.fasta//g') && samples=($samples)

# make the directories if they don't exist
[ -d /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/chimeric ] ||  mkdir /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/chimeric
[ -d /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/chimera_ids ] || mkdir /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/chimera_ids
[ -d /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/non_chimeric ] || mkdir /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/non_chimeric


for sample in ${samples[*]}; do

	if [ -e /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/non_chimeric/${sample}.fasta ]; then
		echo "Chimera already checked for ${sample}, I am continuing with the next sample"
		continue
	fi

# Reference based chimera detection using usearch
/gpfs0/biores/users/gilloro/Biyi/USEARCH11/usearch \
	-uchime2_ref /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/${sample}.fasta \
	-db /gpfs0/biores/users/gilloro/Biyi/databases/SILVA_132_QIIME_release/rep_set/rep_set_16S_only/99/silva_132_99_16S.fna \
	 -chimeras /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/chimeric/${sample}_chimera.fasta\
	 -strand plus \
	-mode sensitive 

# Get the chimeric sequences ids  
grep ">" /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/chimeric/${sample}_chimera.fasta | \
	 perl -ne '/^>(.+)\s+run.+/; print "$1\n"' > /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/chimera_ids/${sample}_chimera.ids

# Get only the non-chimeric reads
#/gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/scripts/get_seq.pl \
#	-s /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/${sample}.fasta \
#	-i /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/chimera_ids/${sample}_chimera.ids \
#	-o /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/non_chimeric/${sample}.fasta \
#	-f n \
#	-p 72
/gpfs0/biores/users/gilloro/Biyi/seqkit grep -vf /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/chimera_ids/${sample}_chimera.ids \
						/gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/${sample}.fasta | \
						perl -pe '$. > 1 and /^>/ ? print "\n" : chomp' > /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/non_chimeric/${sample}.fasta

done

