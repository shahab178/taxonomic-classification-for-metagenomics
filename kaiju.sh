#!/bin/bash

cd XX

kaiju -z 16 -t /.../kaiju/refseq/nodes.dmp -f /.../kaiju/refseq/kaiju_db_refseq.fmi -i seq_PE_1.fq -j seq_PE_2.fq -o kaiju.out

kaiju2krona -t /.../kaiju/refseq/nodes.dmp -n /.../kaiju/refseq/names.dmp -i kaiju.out -o kaiju.out.krona

ktImportText -o kaiju.out.html kaiju.out.krona

kaiju2table -u -e -t /.../kaiju/refseqb/nodes.dmp -n /.../kaiju/refseq/names.dmp -r species -u -o kaiju_summary.tsv kaiju.out

kaiju-addTaxonNames -u -r species -t /.../kaiju/refseq/nodes.dmp -n /.../kaiju/refseq/names.dmp -i kaiju.out -o kaiju.names.out

sort -k2,2 kaiju.names.out > kaiju.names.out.sort

mkdir kaiju_output

mv kaiju.out kaiju_summary.tsv kaiju.names.out kaiju.names.out.sort kaiju.out.krona kaiju_output/

#De novo assembley
spades.py -t 16 --pe1-1 seq_PE_1.fq --pe1-2 seq_PE_2.fq -o spades_output

cd spades_output

grep '^>' contigs.fasta -c > number_of_contigs.txt

cd ..
# Repeat with the de novo assembley's result
kaiju -z 16 -t /.../kaiju/refseq/nodes.dmp -f /.../kaiju/refseq/kaiju_db_refseq.fmi -i /.../samples/F06/spades_output/contigs.fasta -o kaiju.contigs.out

kaiju2table -u -e -t /.../kaiju/refseq/nodes.dmp -n /.../kaiju/refseq/names.dmp -r species -u -o kaiju.contigs_summary.tsv kaiju.contigs.out

kaiju-addTaxonNames -u -r species -t /.../kaiju/refseq/nodes.dmp -n /.../kaiju/refseq/names.dmp -i kaiju.contigs.out -o kaiju.contigs.names.out


sort -k2,2 kaiju.contigs.names.out > kaiju.contigs.names.out.sort

mkdir kaiju.contigs_output

mv kaiju.contigs.out kaiju.contigs_summary.tsv kaiju.contigs.names.out kaiju.contigs.names.out.sort kaiju.contigs_output/

cd ..
