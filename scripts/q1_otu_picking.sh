#! /bin/bash
#$ -S /bin/bash
#$ -q bioinfo.q
#$ -V
#$ -cwd
#$ -N q1_otu_picking
#$ -pe shared 72

# modify the environment for Qiime
export PATH="/storage16/app/bioinfo/blast-2.2.22/bin:/fastspace/bioinfo_apps/cdbfasta:/fastspace/bioinfo_apps/microbiomeutil-r20110519/ChimeraSlayer:/fastspace/bioinfo_apps/qiime/usr/local/bin:/fastspace/bioinfo_apps/qiime/local/bin:/bin:/usr/bin" PYTHONPATH="/fastspace/bioinfo_apps/qiime/usr/local" HDF5_DIR="/fastspace/bioinfo_apps/qiime/local/hdf5" RDP_JAR_PATH="/fastspace/bioinfo_apps/qiime/local/rdp_classifier_2.2/rdp_classifier-2.2.jar"QIIME_CONFIG_FP="/fastspace/bioinfo_apps/qiime/qiime_config_biores"



#pick open reference otus
pick_open_reference_otus.py -i /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/02.demultiplexing/combined_seqs.fna -r /gpfs0/biores/users/gilloro/Biyi/SILVA_132_QIIME_release/rep_set/rep_set_16S_only/97/silva_132_97_16S.fna -o /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/03.otu_picking/q1_otu_picking/ -p /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/scripts/parameter_file.txt -m sortmerna_sumaclust -f


