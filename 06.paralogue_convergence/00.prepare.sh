~/software/RaxML/standard-RAxML-8.2.10/raxmlHPC-PTHREADS -m PROTGAMMAWAG -s hsp90.fa -T 24 -n protein -p 31415
~/software/RaxML/standard-RAxML-8.2.10/raxmlHPC-PTHREADS -m PROTGAMMAWAG -s hsp90.fa -T 24 -n ancestral -p 31415 -f A -t reroot.tre
~/software/seqgen/Seq-Gen/source/seq-gen -n100000 -m WAG -wa -k1 seqgen.ctl > simulate.phy
