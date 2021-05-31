#! /bin/bash
#$ -S /bin/bash
#$ -q bioinfo.q
#$ -V
#$ -cwd
#$ -N split_assign_tax
#$ -pe shared 5
#$ -M obadbotanist@yahoo.com


set -e
unset module
# modify the environment for Qiime
export PATH="/storage16/app/bioinfo/blast-2.2.22/bin:/fastspace/bioinfo_apps/cdbfasta:/fastspace/bioinfo_apps/microbiomeutil-r20110519/ChimeraSlayer:/fastspace/bioinfo_apps/qiime/usr/local/bin:/fastspace/bioinfo_apps/qiime/local/bin:/bin:/usr/bin" PYTHONPATH="/fastspace/bioinfo_apps/qiime/usr/local" HDF5_DIR="/fastspace/bioinfo_apps/qiime/local/hdf5" RDP_JAR_PATH="/fastspace/bioinfo_apps/qiime/local/rdp_classifier_2.2/rdp_classifier-2.2.jar" QIIME_CONFIG_FP="/fastspace/bioinfo_apps/qiime/qiime_config_biores" HDF5_DIR="/fastspace/bioinfo_apps/qiime/local/hdf5" RDP_JAR_PATH="/fastspace/bioinfo_apps/qiime/local/rdp_classifier_2.2/rdp_classifier-2.2.jar" WORKING_DIR="/gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/16S_nanopore/" BULK_DIR="/gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/16S_nanopore/trimmed_reads/fasta/non_chimeric/" FILE_PATTERN='x*fasta' OUT_DIR="/gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/16S_nanopore/blast_taxonomy/" CONDA_PATH='/gpfs0/biores/users/gilloro/home/miniconda3/' SILVA_DATABASE="/gpfs0/biores/users/gilloro/Biyi/databases/SILVA_132_QIIME_release/" ID2TAX="/gpfs0/biores/users/gilloro/Biyi/databases/SILVA_132_QIIME_release/taxonomy/16S_only/99/consensus_taxonomy_7_levels.txt" REF_DB="/gpfs0/biores/users/gilloro/Biyi/databases/SILVA_132_QIIME_release/rep_set/rep_set_16S_only/99/silva_132_99_16S.fna" METHOD="blast"

source ${CONDA_PATH}/bin/activate ${CONDA_PATH}

SAMPLES=(BC13 BC25 BC29 BC37 BC49 BC50 BC61 BC62 BC65 BC73 BC74 BC85 BC86)

function create_script(){

local SAMPLE=$1
cp /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/16S_nanopore/scripts/split_assign_tax_qsub.sh \
 /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/16S_nanopore/blast_taxonomy/${SAMPLE}_taxonomy/${SAMPLE}_assign_tax.sh

sed -E -i "s/SAMPLE=/SAMPLE=${SAMPLE}/g" /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/16S_nanopore/blast_taxonomy/${SAMPLE}_taxonomy/${SAMPLE}_assign_tax.sh 
sed -E -i "s/split_assign_tax/${SAMPLE}_assign_tax/g" /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/16S_nanopore/blast_taxonomy/${SAMPLE}_taxonomy/${SAMPLE}_assign_tax.sh

}

export -f create_script

parallel --jobs 0 \
create_script ::: ${SAMPLES[*]}

SCRIPTS=$(find /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/16S_nanopore/blast_taxonomy/ -name "*.sh")

SCRIPTS=($SCRIPTS)

# Run 3 parallelized scripts each time
for i in $(seq 0 3 ${#SCRIPTS[*]});do

	CURRENT_SCRIPTS=$(echo ${SCRIPTS[*]:${i}:3})
	parallel --jobs 0 \
	/storage/SGE6U8/bin/lx24-amd64/qsub ::: ${CURRENT_SCRIPTS}

done

