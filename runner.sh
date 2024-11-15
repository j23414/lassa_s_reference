#! /usr/bin/env bash

set -eu

export manual_alignment=../phylogenetic/data/gpc/manual_alignment.fasta
export metadata=../phylogenetic/data/gpc/metadata.tsv
export sequences=../ingest/results/all/sequences.fasta

# Only full length samples
augur filter \
  --sequences ${manual_alignment} \
  --metadata ${metadata} \
  --metadata-id-columns accession \
  --query 'length>3000' \
  --output-sequences long.fasta

# Only unique samples
smof uniq \
  --pack \
  --pack-sep '|' \
  long.fasta \
  | sed 's/|.*//g' \
  > unique.fasta

# Sample 50
smof sample -n 50 \
  unique.fasta \
  > sample_X.fasta

# Pull
grep ">" sample_X.fasta \
  | sed 's/>//g' \
  > sample_X.ids

smof grep -f sample_X.ids \
  ${sequences} \
  > s.fasta

smof grep -v -f drop.ids s.fasta > s_filter.fasta

mafft --auto --adjustdirection --thread 4 s_filter.fasta > s_aln.fasta

cat sample_X.fasta \
  | sed 's/>/>REF|/g' \
  > ref.fasta

cat ref.fasta s_aln.fasta > s_try.fasta

# Delete strange sequences and place ID in drop.ids
# Pull out non-reference strains
smof grep -v "REF" s_try_modified.fasta > s_ref.fasta