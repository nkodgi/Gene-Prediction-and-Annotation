#!/bin/bash

# Create or clear log file
echo "GFFRead Processing Log" > log3.txt

# Loop through all .gff files in your directory
for gff_file in *.gff; do
    # Get the base name of the .gff file without extension (e.g., D1742262_S01_L001-SKESA_contigs.gff -> D1742262_S01_L001-SKESA_contigs)
    base_name=$(basename "$gff_file" .gff)
    
    # Find the associated .fna file (replace with your actual pattern matching if necessary)
    fna_file="${base_name}-SKESA_contigs.fasta"
    
    # Check if the .fna file exists
    if [ -f "$fna_file" ]; then
        # Run gffread and log output to log3.txt
        echo "Processing $gff_file with $fna_file..." >> log3.txt
        gffread "$gff_file" -g "$fna_file" -x "${base_name}_cds.fasta" >> log3.txt 2>&1
        echo "Finished processing $gff_file" >> log3.txt
    else
        echo "Error: Associated .fna file $fna_file not found for $gff_file" >> log3.txt
    fi
done
