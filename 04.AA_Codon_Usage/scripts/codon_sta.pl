#! /usr/bin/env perl
use strict;
use warnings;
use Bio::Seq;

my ($file)=@ARGV;
die "Usage: $0 <aligned fasta file>\n" if(@ARGV<1);

my %base;
my $reader="~/bio_tools/00.scripts/read_fasta.pl";
open I,"perl $reader $file |";
my $len=0;
my @id;
while (my $id=<I>) {
    chomp $id;
    my $seq=<I>;
    chomp $seq;
    push @id,$id;
    $len=length($seq);
    my @base=split(//,$seq);
    for(my $i=0;$i<@base;$i+=3){
        my $codon=$base[$i].$base[$i+1].$base[$i+2];
        my $amino=&translate_nucl($codon);
        $base{$amino}{$codon}{$id}++;
    }
}
close I;

print "#amino\tcodon\tspecies\tcount\n";
foreach my $amino(sort keys %base){
    foreach my $codon(sort keys %{$base{$amino}}){
        foreach my $id(@id){
            my $count=0;
            if(exists $base{$amino}{$codon}{$id}){
	$count=$base{$amino}{$codon}{$id};
            }
            print "$amino\t$codon\t$id\t$count\n";
        }
        print "\n";
    }
    print "\n";
}

sub translate_nucl{
    my $seq=shift;
    my $seq_obj=Bio::Seq->new(-seq=>$seq,-alphabet=>'dna');
    my $pro=$seq_obj->translate;
    $pro=$pro->seq;
    return($pro);
}
