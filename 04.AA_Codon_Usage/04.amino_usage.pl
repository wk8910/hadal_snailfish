#! /usr/bin/env perl
use strict;
use warnings;

my $in="03.collect.pl.out";
my $out="$0.out";

my %hash;
open I,"< $in";
while (<I>) {
    chomp;
    next if(/^\s*$/);
    next if(/^#/);
    my @a=split(/\s+/);
    my ($amino,$codon,$species,$count)=@a;
    next unless($species=~/ds|ss|gac/);
    $hash{$amino}{$species}+=$count;
}
close I;

open O,"> $out";
print O "amino\tspecies\tcount\n";
foreach my $amino(sort keys %hash){
    foreach my $species(sort keys %{$hash{$amino}}){
        print O "$amino\t$species\t$hash{$amino}{$species}\n";
    }
}
close O;
