#! /usr/bin/env perl
use strict;
use warnings;

my $indir="genes";
my @dir=<$indir/*>;

open O,"> $0.sh";
foreach my $dir(@dir){
    print O "perl scripts/amino_sta.pl $dir/clean.fa > $dir/amino.sta; Rscript -e \"a=read.table(\\\"$dir/amino.sta\\\",header=T); b=cor(a\\\$ds,a\\\$gac); c=cor(a\\\$ds,a\\\$ss); d=cor(a\\\$gac,a\\\$ss); line=paste(b,c,d); write.table(line,quote=F,row.names=FALSE,col.names=FALSE);\" > $dir/amino.sta.cor\n";
}
close O;
