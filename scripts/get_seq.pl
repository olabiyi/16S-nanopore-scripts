#!/usr/bin/env perl
# Find a list of sequences with given sequence ids from a fasta file
use strict;
use v5.24;
use Getopt::Long;
use Pod::Usage;
use Parallel::ForkManager;

my ($parallel,$help);
my ($seqFile,$idsFile,$outFile);
my $filter;

my $res = GetOptions("seqFile=s" => \$seqFile,
			"idsFile=s"=>\$idsFile,
			"outFile=s"=>\$outFile,
		     "parallel:i"=>\$parallel, # the : means parallel is an optional arguement
		     "filter=s"=>\$filter,
		     "help"=>\$help,
    )or pod2usage(2);

pod2usage(-verbose=>2) if $help;


# Exit if flag is not correctly specified
unless($filter =~ /[pPnN]/){
	say "Invalid flag. Flag can only be pP or nN for positive or negative filtering, respectively";
	exit;
}

my $cpu_count=1;
#if the option is set
if(defined($parallel)){
    #option is set but with no value then use the max number of proccessors
    if($parallel ==0){
	#load this module dynamically
	eval("use Sys::CPU;");
	$cpu_count=Sys::CPU::cpu_count();
    }else{
	$cpu_count=$parallel;
    }
}


# Open the required files
open(SEQFILE,'<',$seqFile) or die "Can't open $seqFile: $!";
open(SEQIDSFILE,'<',$idsFile) or die "Can't open $idsFile: $!";
open(OUTFILE,'>',$outFile) or die "Please provide an output file name $outFile is invalid: $!";


# Read the sequence ids provided in seqidsFile into an array
my @seq_ids = <SEQIDSFILE>;
chomp @seq_ids;

# change the file record separator to '>'
my $input_record_separator = $/;
$/ = '>';
my @sequences = <SEQFILE>;
$/ = $input_record_separator;


# append > to the beginning of the output file
# because for some reason its missing whenever i print
print OUTFILE '>';

# Positive filtering
if ($filter =~ /^[pP]/){
	
	foreach my $seq_id (@seq_ids){
		# grep will get the item only in array context
		# scalar context will give only counts of matches
		my @found_seq = grep(/$seq_id/,@sequences);
		print OUTFILE @found_seq;
		
	}

		
# Negative filtering
}elsif($filter =~ /^[nN]/){
	# store all the sequences as keys in the all_seqs hash
	my %all_seqs;
	@all_seqs{@sequences} = ();
	my @found_sequences =();
	foreach my $seq_id (@seq_ids){
		# grep will get the item only in array context
		# scalar context will give only counts of matches
		my @seq = grep(/$seq_id/,@sequences);
		push(@found_sequences,@seq);
	}
	# Delete the found sequences from all the sequences 
	delete @all_seqs{@found_sequences};
	# get the negative sequences and print
	my @negative_seqs = keys %all_seqs;
	# Delete the trailing > sign
	$negative_seqs[(scalar @negative_seqs)-1] =~ s/>//;
	print OUTFILE @negative_seqs;
	
}else{
	say "Invalid selection. selection can only be pP or nN for positive or negative filtering, respectively";
	exit;
}


__END__
=head1 Name

get_fasta_sequences.pl - A simple script to filter reads from a fasta file

=head1 USAGE
get_fasta_sequences.pl -s <seqFile> -i <idsFile> -o <outFile> -f <filter> [-p [<# proc>] -h]

# Example - Get reads that are not specified in the idsFile(i), Run in parallel and use all CPUs

get_fasta_sequences.pl -s "seqs.fna" -i seq_ids.txt -o my_seqs.txt -f n  -p


# get the reads that are specified in the idsFile(i), run in parallel limit to only 2 CPUs

get_fasta_sequences.pl -s "seqs.fna" -i seq_ids.txt -o my_seqs.txt -f p  -p 2

=head1 OPTIONS

=over 4

=item B<-s, --seqFile <file>>

The name of the fasta file you'll like to filter.

=item B<-p, --parallel [<# of proc>]>

Using this option without a value will use all CPUs on machine, while giving it a value will limit to that many CPUs. Without option only one CPU is used. 


=item B<-i, --idsFile <file>>

A name or path of a file with the sequence ids to filter each on a separate line.

=item B<-o, --outFile <file>>

The name of the file to write the filtered reads to.

=item B<-f, --filter <string>>

A string which can be either p|P or n|N for positive or negative filtering, respectively.

=item B<-h, --help>

Displays the entire help documentation.

=back

=head1 DESCRIPTION

B<get_fasta_sequences.pl> This script allows for positive or negative selection of sequences from a fasta file

The script allows the use of multiple threads. 

=head1 AUTHOR

Olabiyi Obayomi, E<lt>obadbotanist@yahoo.comE<gt>

=cut
