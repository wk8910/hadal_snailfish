#! /usr/bin/env perl
use strict;
use warnings;

my $indir="genes";

my %hash;
my @files=<$indir/*/codon.sta>;

foreach my $file(@files){
    open I,"< $file";
    while (<I>) {
        chomp;
        next if(/^#/);
        next if(/^\s*$/);
        my @a=split(/\s+/);
        my ($amino,$codon,$species,$count)=@a;
        $hash{$amino}{$codon}{$species}+=$count;
    }
    close I;
}

open O,"> $0.out";
print O "#amino\tcodon\tspecies\tcount\n";
foreach my $amino(sort keys %hash){
    foreach my $codon(sort keys %{$hash{$amino}}){
        foreach my $species(sort keys %{$hash{$amino}{$codon}}){
            my $count=$hash{$amino}{$codon}{$species};
            print O "$amino\t$codon\t$species\t$count\n";
        }
        print O "\n";
    }
    print O "\n";
}
close O;
