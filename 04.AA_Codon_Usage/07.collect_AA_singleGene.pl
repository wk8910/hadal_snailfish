#! /usr/bin/env perl
use strict;
use warnings;

my $lst="06.single_gene_AA.pl.sh";

open O,"> $0.out";
open I,"< $lst";
while (<I>) {
    chomp;
    /(\S+)$/;
    my $file=$1;
    $file=~/genes\/([^\/]+)/;
    my $geneid=$1;
    open F,"< $file";
    while (<F>) {
        chomp;
        my @a=split(/\s+/);
        my ($ds_sti,$ds_ss,$ss_sti)=@a;
        print O "$geneid\t$ds_sti\t$ds_ss\t$ss_sti\n";
    }
    close F;
}
close I;
close O;
