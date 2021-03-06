#!/usr/bin/perl -w

# Change vcf file generated by GATK within Bcbio-nextgen to suit Cartagenia (adjusted for NextGene).
# to use type perl Vcf_bcbio_to_Cartagenia.pl <infile> <outfile>
use strict;
use warnings;

my $infile=shift @ARGV;
my $outfile=shift @ARGV;
my @data;
my @numbers;
my $AFnew;
my $AFnew1;
my $AFnew2;
my $numbersline;
my @info;
my $infoline;

open IN,$infile; 
open OUT,">$outfile";

while (<IN>) {
	chomp;
	if ($_ =~ m/^#/) {
	    print OUT "$_\n";
    } 
    else {		
		@data=split(/\s+/, $_);
		if ($data[8] ne "GT:AD:DP:GQ:PL") {
			print OUT join("\t", @data);
			print OUT "\n";			
		} else {
			@numbers=split(/[:,\s]+/, $data[9]);
			if ($data[4]=~m/,/) {
				if ($numbers[1] == "0" && $numbers[2] == "0" && $numbers[3] == "0") {
					$AFnew1=0;
					$AFnew2=0;
				} else {
					$AFnew1=($numbers[2]/($numbers[1] + $numbers[2] + $numbers[3]));
					$AFnew2=($numbers[3]/($numbers[1] + $numbers[2] + $numbers[3]));
				}
				$numbersline="$numbers[0]\:$numbers[1]\,$numbers[2]\,$numbers[3]\:$numbers[4]\:$numbers[5]\:$numbers[6]\,$numbers[7]\,$numbers[8]\,$numbers[9]\,$numbers[10]\,$numbers[11]";
				@info=split("\;", $data[7]);
				$info[1]="AF=$AFnew1,$AFnew2";
				$infoline=join("\;", @info);
				print OUT "$data[0]\t$data[1]\t$data[2]\t$data[3]\t$data[4]\t$data[5]\t$data[6]\t$infoline\t$data[8]\t$numbersline\n";
			} else {
				if ($numbers[1] == "0" && $numbers[2] == "0") {
					$AFnew=0;
				} else {		
					$AFnew=($numbers[2]/($numbers[1] + $numbers[2]));
				}
				if ($data[0] eq "chrY" || $data[0] eq "chrM") {
					$numbersline="$numbers[0]\:$numbers[1]\,$numbers[2]\:$numbers[3]\:$numbers[4]\:$numbers[5]\,$numbers[6]";		
				} else {		
					$numbersline="$numbers[0]\:$numbers[1]\,$numbers[2]\:$numbers[3]\:$numbers[4]\:$numbers[5]\,$numbers[6]\,$numbers[7]";
				}
				@info=split("\;", $data[7]);
				$info[1]="AF=$AFnew";
				$infoline=join("\;", @info);
				print OUT "$data[0]\t$data[1]\t$data[2]\t$data[3]\t$data[4]\t$data[5]\t$data[6]\t$infoline\t$data[8]\t$numbersline\n";
			}
		}
	}
}
close OUT;