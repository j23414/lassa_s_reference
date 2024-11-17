# lassa_s_reference
Attempt an S reference

To be equivalent to the gpc alignment reference (maintaining pos60):

1. Pull samples from gpc alignment which are full length (>3000nt)
2. Drop duplicate sequences in the gpc region
3. Randomly sample ~50
4. Align the smaller sample
5. Open in Geneious Prime, manually match against GPC manual alignment
6. Export as s_ref.fasta
