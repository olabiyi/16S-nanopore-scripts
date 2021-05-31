#! /bin/bash
#$ -S /bin/bash
#$ -q bioinfo.q
#$ -V
#$ -cwd
#$ -N filtered_blast_assign_tax
#$ -pe shared 72

# modify the environment for Qiime
export PATH="/storage16/app/bioinfo/blast-2.2.22/bin:/fastspace/bioinfo_apps/cdbfasta:/fastspace/bioinfo_apps/microbiomeutil-r20110519/ChimeraSlayer:/fastspace/bioinfo_apps/qiime/usr/local/bin:/fastspace/bioinfo_apps/qiime/local/bin:/bin:/usr/bin" PYTHONPATH="/fastspace/bioinfo_apps/qiime/usr/local" HDF5_DIR="/fastspace/bioinfo_apps/qiime/local/hdf5" RDP_JAR_PATH="/fastspace/bioinfo_apps/qiime/local/rdp_classifier_2.2/rdp_classifier-2.2.jar"QIIME_CONFIG_FP="/fastspace/bioinfo_apps/qiime/qiime_config_biores"

#actual command
HDF5_DIR="/fastspace/bioinfo_apps/qiime/local/hdf5" RDP_JAR_PATH="/fastspace/bioinfo_apps/qiime/local/rdp_classifier_2.2/rdp_classifier-2.2.jar" 

files=$(ls /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/non_chimeric/*fasta |sed 's/\/gpfs0\/biores\/users\/gilloro\/Biyi\/hinuman_analysis\/trimmed_reads\/fasta\/non_chimeric\///g')
files=($files)

#mkdir /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/filtered_rdp_taxonomy
mkdir /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/filtered_blast_taxonomy

method="blast"

for f in ${files[*]}
do
sample=$(echo $f |sed s/_reduced_filtered\.fasta//)

if [ "$method" == "rdp" ]; then

#assign taxonomy using rdp classifier
assign_taxonomy.py -o /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/filtered_rdp_taxonomy/${sample}_taxonomy -i /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/non_chimeric/${f} --confidence 0.5 --id_to_taxonomy_fp /gpfs0/biores/users/gilloro/Biyi/SILVA_132_QIIME_release/taxonomy/16S_only/97/consensus_taxonomy_7_levels.txt --assignment_method rdp -r /gpfs0/biores/users/gilloro/Biyi/SILVA_132_QIIME_release/rep_set/rep_set_16S_only/97/silva_132_97_16S.fna --rdp_max_memory 50000

elif [ "$method" == "blast" ]; then

#assign taxonomy using Blast
assign_taxonomy.py -o /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/filtered_blast_taxonomy/${sample}_taxonomy -i /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/trimmed_reads/fasta/non_chimeric/${f} --id_to_taxonomy_fp /gpfs0/biores/users/gilloro/Biyi/SILVA_132_QIIME_release/taxonomy/16S_only/97/consensus_taxonomy_7_levels.txt --assignment_method blast -r /gpfs0/biores/users/gilloro/Biyi/SILVA_132_QIIME_release/rep_set/rep_set_16S_only/97/silva_132_97_16S.fna --blast_e_value 0.01

fi

done


cd /gpfs0/biores/users/gilloro/Biyi/hinuman_analysis/filtered_blast_taxonomy/

mkdir together
for dir in $(ls); do if [ $dir == together/ ]; then continue; fi; cp $dir/*txt together/; done
