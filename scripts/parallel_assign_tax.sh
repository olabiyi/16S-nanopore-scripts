#! /bin/bash
#$ -S /bin/bash
#$ -q bioinfo.q
#$ -V
#$ -cwd
#$ -N assign_tax
#$ -pe shared 72
#$ -M obadbotanist@yahoo.com

# modify the environment for Qiime
export PATH="/storage16/app/bioinfo/blast-2.2.22/bin:/fastspace/bioinfo_apps/cdbfasta:/fastspace/bioinfo_apps/microbiomeutil-r20110519/ChimeraSlayer:/fastspace/bioinfo_apps/qiime/usr/local/bin:/fastspace/bioinfo_apps/qiime/local/bin:/bin:/usr/bin" PYTHONPATH="/fastspace/bioinfo_apps/qiime/usr/local" HDF5_DIR="/fastspace/bioinfo_apps/qiime/local/hdf5" RDP_JAR_PATH="/fastspace/bioinfo_apps/qiime/local/rdp_classifier_2.2/rdp_classifier-2.2.jar"QIIME_CONFIG_FP="/fastspace/bioinfo_apps/qiime/qiime_config_biores"

#actual command
HDF5_DIR="/fastspace/bioinfo_apps/qiime/local/hdf5" RDP_JAR_PATH="/fastspace/bioinfo_apps/qiime/local/rdp_classifier_2.2/rdp_classifier-2.2.jar" 
READS_DIR="/gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/16S_nanopore/trimmed_reads/fasta/non_chimeric/"
FILE_PATTERN='x*fasta' #'*fasta'
OUT_DIR='/gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/16S_nanopore/blast_taxonomy' #/gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/rdp_taxonomy
FILES=$(basename -a $(ls ${READS_DIR}${FILE_PATTERN}))
CONDA_PATH='/gpfs0/biores/users/gilloro/home/miniconda3/'
ID2TAX='/gpfs0/biores/users/gilloro/Biyi/databases/SILVA_132_QIIME_release/taxonomy/16S_only/99/consensus_taxonomy_7_levels.txt'
REF_DB='/gpfs0/biores/users/gilloro/Biyi/databases/SILVA_132_QIIME_release/rep_set/rep_set_16S_only/99/silva_132_99_16S.fna'
METHOD="blast"
[ -d ${OUT_DIR} ] || mkdir ${OUT_DIR}

source ${CONDA_PATH}/bin/activate ${CONDA_PATH}
if [ "${METHOD}" == "rdp" ]; then

#assign taxonomy using rdp classifier
parallel --jobs 0  \
assign_taxonomy.py -o ${OUT_DIR}/{/.}_taxonomy -i ${READS_DIR}/{} --confidence 0.5 --id_to_taxonomy_fp ${ID2TAX} --assignment_method rdp -r ${REF_DB} --rdp_max_memory 50000 ::: ${FILES}

elif [ "${METHOD}" == "blast" ]; then

#assign taxonomy using Blast
parallel --jobs 0 \
assign_taxonomy.py -o ${OUT_DIR}/{/.}_taxonomy -i ${READS_DIR}/{} --id_to_taxonomy_fp ${ID2TAX} --assignment_method blast -r ${REF_DB} --blast_e_value 0.01 ::: ${FILES}

fi

#cd ${OUT_DIR}

#[ -d together ] || mkdir together
#for dir in $(ls); do if [ $dir == together/ ]; then continue; fi; cp $dir/*txt together/; done
