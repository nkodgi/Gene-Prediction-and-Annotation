#!/usr/bin/env python3

import glob

log_file = "log2.txt"  # Log file

with open(log_file, "w") as log:
    for input_file in glob.glob("*.predict"):  # Find all .predict files
        output_file = input_file.replace(".predict", ".gff")  # Change extension
        
        with open(input_file, "r") as infile, open(output_file, "w") as outfile:
            outfile.write("##gff-version 3\n")  # GFF3 version header
            log.write(f"Processing input file: {input_file}\n")

            seqname = ""  # SeqID

            for line in infile:
                if line.startswith(">"):  # Contig Detection
                    seqname = line.strip().lstrip(">")
                    log.write(f"\nProcessing contig: {seqname}\n")
                    continue  # Skip

                parts = line.split()
                if len(parts) < 5:  # Skip incomplete ORF
                    log.write(f"Skipping incomplete line: {line.strip()}\n")
                    continue

                source = "Glimmer3"  # Source
                feature = "CDS"  # Feature
                start = min(int(parts[1]), int(parts[2]))  # Ensure Start < End
                end = max(int(parts[1]), int(parts[2]))
                score = parts[4]  # ORF Score

                # Strand Representation
                strand = "+" if parts[3] in ["+1", "1", "+2", "2", "+3", "3"] else "-"

                # Attributes (ORF ID)
                attribute = f"ID={parts[0]};Name=Glimmer_predicted_CDS"

                # GFF line for ORF
                gff_line = f"{seqname}\t{source}\t{feature}\t{start}\t{end}\t{score}\t{strand}\t0\t{attribute}\n"
                outfile.write(gff_line)
                log.write(f"Written ORF: {gff_line.strip()}\n")

        log.write(f"\nGFF file created successfully: {output_file}\n")
        print(f"GFF file created: {output_file}")

