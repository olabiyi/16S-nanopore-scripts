#!/usr/bin/bash

#$1 is the directory containing assigned samples
#$2 is the suffix to add to the sample name
#$3 directory to move samples from
#$4 directory to move samples to

echo "$1, $2, $3,$4"
# function to move assigned sample to a newly created folder 
move_assigned_samples () {

	local dir=$1
	local samples=$(ls $dir | sed 's/_taxonomy//g') && samples=($samples)
	local num_of_samples=${#samples[*]}
	num_of_samples=$(( num_of_samples-1 ))
	local suffix="$2"
	
	# here we are moving files with names listed in the array samples
	for i in $(seq 0 "$num_of_samples")
	do 
	move="${samples[$i]}$suffix" 
	mv "$3$move" "$4"
	done

}

#USAGE
#mkdir data/tax_assigned/
#unfiltered samples
#move_assigned_samples #rdp_taxonomy/ "_reduced.fasta"  data/ data/tax_assigned/

#mkdir trimmed_reads/fasta/tax_assigned/
#filter-samples
move_assigned_samples filtered_rdp_taxonomy/ "_reduced.fasta" trimmed_reads/fasta/  trimmed_reads/fasta/tax_assigned/



ExtractBashComments() {

	egrep "^#"

}

#usage 
# comments=$(ExtractBashComments < myscript.sh)


SumLines() {

#iterating over stdin - similar to awk

	local sum=0
	local line=""
	while read line;do
		sum=$(( ${sum} + ${line} ))
	done
	echo ${sum}

}

#usage 
#SumLines < data_one_number_per_line.txt

log() {

	# classic logger
	local prefix="[$(date +%Y/%m/%d\ %H:%M:%S)]: "
	echo "${prefix} $@" >&2

}

#usage
#log "INFO" "a message"
