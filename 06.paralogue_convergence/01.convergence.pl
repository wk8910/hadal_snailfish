#! /usr/bin/env perl
use strict;
use warnings;

my $phy="simulate.phy";
my $ctl="convergence.ctl";

my %link;
my %record;
open I,"< $ctl";
while (<I>) {
    chomp;
    my @a=split(/\s+/);
    my ($ancestor,$offspring)=@a;
    $link{$ancestor}=$offspring;
    $record{$ancestor}=1;
    $record{$offspring}=1;
}
close I;

open I,"< $phy";
<I>;
my $control=0;
while (my $line=<I>) {
    my @content=($line);
    while (my $l=<I>) {
        last if($l=~/^\s/);
        push @content,$l;
    }
    &proceed(@content);
    # last if($control++>10);
}
close I;

sub proceed{
    my @content=@_;
    my %base;
    my $length=0;
    my %checking;
    foreach my $l(@content){
        chomp $l;
        my @a=split(/\s+/,$l);
        my ($id,$seq)=@a;
        next unless(exists $record{$id});
        $checking{$id}=1;
        # print "$l\n";
        my @base=split(//,$seq);
        $length = scalar(@base) if($length==0);
        for(my $i=0;$i<@base;$i++){
            $base{$id}{$i}=$base[$i];
        }
    }
    my $light=1;
    foreach my $id(keys %record){
        if(!exists $checking{$id}){
            $light=0;
        }
    }
    return() if($light==0);
    my %convergence;
    foreach my $ancestor(sort keys %link){
        my $offspring=$link{$ancestor};
        for(my $i=0;$i<$length;$i++){
            my $a_base=$base{$ancestor}{$i};
            my $o_base=$base{$offspring}{$i};
            if($o_base ne $a_base){
	my $signal=$a_base.$o_base;
	$convergence{$i}{$signal}++;
            }
        }
    }
    my $line="s";
    foreach my $i(sort {$a<=>$b} keys %convergence){
        foreach my $signal(sort keys %{$convergence{$i}}){
            my $count=$convergence{$i}{$signal};
            if($count>1){
	$line.="\t$i:$signal:$count"
            }
        }
    }
    print "$line\n";
}
