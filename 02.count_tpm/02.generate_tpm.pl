#! /usr/bin/env perl
use strict;
use warnings;

my $dir="count";
my $len="cds.len";
my $rpkm_out="$0.tpm";
my $count_out="$0.count";

my %len;
open I,"< $len";
while (<I>) {
    chomp;
    my @a=split(/\s+/);
    my ($id,$len,$e_len)=@a;
    $len{$id}=$e_len;
}
close I;

my @txt=<$dir/*.count>;
my %count;
my %rpkm;
my @sample_id;
foreach my $txt(@txt){
    $txt=~/\/([^\/]+).count/;
    my $sample_id=$1;
    push @sample_id,$sample_id;
    my $total=0;
    open I,"< $txt";
    while (<I>) {
        chomp;
        my @a=split(/\s+/);
        my ($id,$count)=@a;
        next if(!exists$len{$id});
        my $len=$len{$id};
        if($len==0){
            #print STDERR "$id\n";
            next;
        }
        my $rate=$count/$len;
        $total+=$rate;
        $count{$sample_id}{$id}=$count;
    }
    foreach my $id(keys %len){
        next if(!exists$len{$id});
        my $len=$len{$id};
        next if($len==0);
        my $count=0;
        if(exists $count{$sample_id}{$id}){
            $count=$count{$sample_id}{$id};
        }
        my $rate=$count/$len;
        # my $rpkm=($count*1e9)/($total*$len);
        my $tpm=($rate/$total)*1e6;
        $rpkm{$id}{$sample_id}{rpkm}=$tpm;
        $rpkm{$id}{$sample_id}{count}=$count;
    }
    close I;
}

open R,"> $rpkm_out";
open C,"> $count_out";
my $head=join "\t",@sample_id;
print R "\t$head\n";
print C "\t$head\n";
foreach my $id(sort keys %rpkm){
    my @rpkm=($id);
    my @count=($id);
    foreach my $sample_id(@sample_id){
        my ($rpkm,$count)=(0,0);
        if(exists $rpkm{$id}{$sample_id}{rpkm}){
            $rpkm = $rpkm{$id}{$sample_id}{rpkm};
        }
        if(exists $rpkm{$id}{$sample_id}{count}){
            $count = $rpkm{$id}{$sample_id}{count};
        }
        push @rpkm,$rpkm;
        push @count,$count;
    }
    my $rpkm_line=join "\t",@rpkm;
    my $count_line=join "\t",@count;
    print R "$rpkm_line\n";
    print C "$count_line\n";
}
close R;
close C;
