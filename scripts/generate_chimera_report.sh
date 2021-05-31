#!/usr/bin/env bash

chimera_report(){

# extract the sample names from qsub's  std err file
perl -ne 'print "$1\n"  if /.+\/(.+)\.fasta/' $1 > samples.txt
# extract the chimera report from qsub's  std err file
perl -ne 'print "$1\n" if /.+(Chimera.+)/' $1  > report.txt

# paste the samples and report files to generate the final report
paste -d '\t' samples.txt report.txt  > chimera_report.txt
# Delete the intermediate files
rm -rf samples.txt report.txt

}


chimera_report $1
