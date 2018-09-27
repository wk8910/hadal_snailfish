#! /usr/bin/env perl
use strict;
use warnings;

my $indir="genes";
my @dir=<$indir/*>;

open O,"> $0.sh";
foreach my $dir(@dir){
    print O "scripts/codon_sta.pl $dir/clean.fa > $dir/codon.sta\n";
}
close O;
