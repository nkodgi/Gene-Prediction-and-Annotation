#!/bin/bash

# Define the list of fasta files
samples=(
    "D0110039_S01_L001-SKESA_contigs.fasta"
    "D0133463_S01_L001-SKESA_contigs.fasta"
    "D0262590_S01_L001-SKESA_contigs.fasta"
    "D0281446_S01_L001-SKESA_contigs.fasta"
    "D0287766_S01_L001-SKESA_contigs.fasta"
    "D0305916_S01_L001-SKESA_contigs.fasta"
    "D0320058_S01_L001-SKESA_contigs.fasta"
    "D0331520_S01_L001-SKESA_contigs.fasta"
    "D0340971_S01_L001-SKESA_contigs.fasta"
    "D0372208_S01_L001-SKESA_contigs.fasta"
    "D0465287_S01_L001-SKESA_contigs.fasta"
    "D0537729_S01_L001-SKESA_contigs.fasta"
    "D0570846_S01_L001-SKESA_contigs.fasta"
    "D0595886_S01_L001-SKESA_contigs.fasta"
    "D0599005_S01_L001-SKESA_contigs.fasta"
    "D0717665_S01_L001-SKESA_contigs.fasta"
    "D0717763_S01_L001-SKESA_contigs.fasta"
    "D0784258_S01_L001-SKESA_contigs.fasta"
    "D1212247_S01_L001-SKESA_contigs.fasta"
    "D1816817_S01_L001-SKESA_contigs.fasta"
    "D0892467_S01_L001-SKESA_contigs.fasta"
    "D1251843_S01_L001-SKESA_contigs.fasta"
    "D1874688_S01_L001-SKESA_contigs.fasta"
    "D1025689_S01_L001-SKESA_contigs.fasta"
    "D1490961_S01_L001-SKESA_contigs.fasta"
    "D2306186_S01_L001-SKESA_contigs.fasta"
    "D1088210_S01_L001-SKESA_contigs.fasta"
    "D1507169_S01_L001-SKESA_contigs.fasta"
    "D2306204_S01_L001-SKESA_contigs.fasta"
    "D1130644_S01_L001-SKESA_contigs.fasta"
    "D1742262_S01_L001-SKESA_contigs.fasta"
    "D2453159_S01_L001-SKESA_contigs.fasta"
    "D1130645_S01_L001-SKESA_contigs.fasta"
    "D1786215_S01_L001-SKESA_contigs.fasta"
)

# Loop through each sample and run Glimmer3
for sample in "${samples[@]}"; do
    output_prefix="${sample%-SKESA_contigs.fasta}"  # Remove '-SKESA_contigs.fasta' to create output name
    echo "Running Glimmer3 for $sample..." | tee -a log1.txt
    glimmer3 -o30 -g150 -t50 "$sample" type_strain_genome.icm "$output_prefix" >> log1.txt 2>&1
    echo "Completed $sample" | tee -a log1.txt
done

echo "All samples processed." | tee -a log1.txt

