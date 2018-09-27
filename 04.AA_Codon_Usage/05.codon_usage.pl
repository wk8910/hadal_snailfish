#! /usr/bin/env perl
use strict;
use warnings;

my $in="03.collect.pl.out";
my $out="$0.out";

my %amino;
open I,"< $in";
while (<I>) {
    chomp;
    next if(/^\s*$/);
    next if(/^#/);
    my @a=split(/\s+/);
    my ($amino,$codon,$species,$count)=@a;
    next unless($species=~/ds|ss|gac/);
    if($species eq "ds"){
        $species = "01.ds"
    }
    if($species eq "ss"){
        $species = "02.ss";
    }
    if($species eq "gac"){
        $species = "03.sti";
    }
    $amino{$amino}{$species}+=$count;
}
close I;

my %hash;
open I,"< $in";
while (<I>) {
    chomp;
    next if(/^\s*$/);
    next if(/^#/);
    my @a=split(/\s+/);
    my ($amino,$codon,$species,$count)=@a;
    next unless($species=~/ds|ss|gac/);
    if($species eq "ds"){
        $species = "01.ds"
    }
    if($species eq "ss"){
        $species = "02.ss";
    }
    if($species eq "gac"){
        $species = "03.sti";
    }
    $hash{$amino}{$codon}{$species}+=$count/$amino{$amino}{$species};
}
close I;

open O,"> $out";
print O "amino\tcodon\tspecies\tcount\n";
foreach my $amino(sort keys %hash){
    foreach my $codon(sort keys %{$hash{$amino}}){
        foreach my $species(sort keys %{$hash{$amino}{$codon}}){
            print O "$amino\t$codon\t$species\t$hash{$amino}{$codon}{$species}\n";
        }
    }
}
close O;
