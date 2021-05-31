#! /bin/bash
#$ -S /bin/bash
#$ -q bioinfo.q
#$ -V
#$ -cwd
#$ -N hinuman_chimera_check
#$ -pe shared 72

# modify the environment for Qiime
export PATH="/storage16/app/bioinfo/blast-2.2.22/bin:/fastspace/bioinfo_apps/cdbfasta:/fastspace/bioinfo_apps/microbiomeutil-r20110519/ChimeraSlayer:/fastspace/bioinfo_apps/qiime/usr/local/bin:/fastspace/bioinfo_apps/qiime/local/bin:/bin:/usr/bin" PYTHONPATH="/fastspace/bioinfo_apps/qiime/usr/local" HDF5_DIR="/fastspace/bioinfo_apps/qiime/local/hdf5" RDP_JAR_PATH="/fastspace/bioinfo_apps/qiime/local/rdp_classifier_2.2/rdp_classifier-2.2.jar"QIIME_CONFIG_FP="/fastspace/bioinfo_apps/qiime/qiime_config_biores"



#loop through every sample while ignoring out files from qsub
for file in $(ls -I "hinuman*"); do 
identify_chimeric_seqs.py -m usearch61 -i $file -r /gpfs0/biores/users/gilloro/Biyi/SILVA_132_QIIME_release/rep_set/rep_set_16S_only/97/silva_132_97_16S.fna -o usearch61_chimera_checking/
cat usearch61_chimera_checking/chimeras.txt >> usearch61_chimera_checking/CHIMERA.txt
cat usearch61_chimera_checking/non_chimeras.txt >> usearch61_chimera_checking/NON_CHIMERA.txt
done

#remove unnessary files
rm -rf usearch61_chimera_checking/*.fasta; rm -rf usearch61_chimera_checking/*.uc; rm -rf usearch61_chimera_checking/*.log; rm -rf usearch61_chimera_checking/*.uchime;
rm -rf usearch61_chimera_checking/chimeras.txt ; rm -rf usearch61_chimera_checking/non_chimeras.txt
