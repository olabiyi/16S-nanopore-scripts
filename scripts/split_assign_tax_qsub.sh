#! /bin/bash
#$ -S /bin/bash
#$ -q bioinfo.q
#$ -V
#$ -cwd
#$ -N split_assign_tax
#$ -pe shared 20
#$ -M obadbotanist@yahoo.com



set -e

# modify the environment for Qiime
export PATH="/storage16/app/bioinfo/blast-2.2.22/bin:/fastspace/bioinfo_apps/cdbfasta:/fastspace/bioinfo_apps/microbiomeutil-r20110519/ChimeraSlayer:/fastspace/bioinfo_apps/qiime/usr/local/bin:/fastspace/bioinfo_apps/qiime/local/bin:/bin:/usr/bin" PYTHONPATH="/fastspace/bioinfo_apps/qiime/usr/local" HDF5_DIR="/fastspace/bioinfo_apps/qiime/local/hdf5" RDP_JAR_PATH="/fastspace/bioinfo_apps/qiime/local/rdp_classifier_2.2/rdp_classifier-2.2.jar"QIIME_CONFIG_FP="/fastspace/bioinfo_apps/qiime/qiime_config_biores"

HDF5_DIR="/fastspace/bioinfo_apps/qiime/local/hdf5" RDP_JAR_PATH="/fastspace/bioinfo_apps/qiime/local/rdp_classifier_2.2/rdp_classifier-2.2.jar" 
WORKING_DIR="/gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/16S_nanopore/"
BULK_DIR="${WORKING_DIR}/trimmed_reads/fasta/non_chimeric/"
FILE_PATTERN='x*fasta' #'*fasta'
OUT_DIR="${WORKING_DIR}/blast_taxonomy/" #${WORKING_DIR}/rdp_taxonomy/
CONDA_PATH='/gpfs0/biores/users/gilloro/home/miniconda3/'
SILVA_DATABASE="/gpfs0/biores/users/gilloro/Biyi/databases/SILVA_132_QIIME_release/"
ID2TAX="${SILVA_DATABASE}/taxonomy/16S_only/99/consensus_taxonomy_7_levels.txt"
REF_DB="${SILVA_DATABASE}/rep_set/rep_set_16S_only/99/silva_132_99_16S.fna"
METHOD="blast"

#SAMPLE-="$1"
SAMPLE=
BULK_FASTA="${BULK_DIR}/${SAMPLE}.fasta"
READS_DIR="${OUT_DIR}/${SAMPLE}_taxonomy/split_files"
[ -d ${READS_DIR} ] || mkdir ${READS_DIR}
cd  ${READS_DIR}

[ -e 'xaa.fasta' ] || split -e --additional-suffix=.fasta ${BULK_FASTA}
FILES=$(basename -a $(ls ${READS_DIR}/${FILE_PATTERN}))

source ${CONDA_PATH}/bin/activate ${CONDA_PATH}

if [ "${METHOD}" == "rdp" ]; then

#assign taxonomy using rdp classifier
#cat ${BULK_FASTA} | parallel --jobs 0 --pipe --recend '\n' --recstart  '>' \
parallel --jobs 0 \
assign_taxonomy.py -o ${READS_DIR}/{/.}_taxonomy -i {} --confidence 0.5 --id_to_taxonomy_fp ${ID2TAX} --assignment_method rdp -r ${REF_DB} --rdp_max_memory 50000 ::: ${FILES}

elif [ "${METHOD}" == "blast" ]; then

#assign taxonomy using Blast
parallel --jobs 0 \
assign_taxonomy.py -o ${READS_DIR}/{/.}_taxonomy -i {} --id_to_taxonomy_fp ${ID2TAX} --assignment_method blast -r ${REF_DB} --blast_e_value 0.01 ::: ${FILES}

fi

find ${READS_DIR} -name *.txt -print | xargs cat  | grep -v "No blast" > ${OUT_DIR}/${SAMPLE}_taxonomy/${SAMPLE}_tax_assignments.txt  && rm -rf ${READS_DIR}

[ -d  ${OUT_DIR}/together ] || mkdir  ${OUT_DIR}/together
cp  ${OUT_DIR}/${SAMPLE}_taxonomy/${SAMPLE}_tax_assignments.txt ${OUT_DIR}/together 
