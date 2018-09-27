#! /usr/bin/env perl
use strict;
use warnings;

my $lst="geneid.lst";
my $indir="../03.extract_sequence/genes";
my $outdir="genes";
`mkdir $outdir` if(!-e $outdir);

my %hash;
open I,"< $lst";
while (<I>) {
    chomp;
    my @a=split(/\s+/);
    my $sti_id=$a[1];
    $hash{$sti_id}++;
}
close I;

foreach my $id(sort keys %hash){
    `mkdir $outdir/$id` if(!-e "$outdir/$id");
    `cp $indir/$id.fa $outdir/$id/cds.fa`;
    # last;
}
