# Prediction with Glimmer3 & Protein Homology Annotation with eggNOG DIAMOND

## Overview
This project involves predicting protein homology across 34 genomes using **Glimmer3** for gene prediction and the **eggNOG CLI** with the **DIAMOND database** for functional annotation. This was originally run on Conda and adapted to run on Docker for the main pipeline script. 
Please see that read.me for information on how to run **Glimmer3** for gene prediction and the **eggNOG CLI** with the **DIAMOND database** on Docker.

The analysis was conducted on:  
- **Ubuntu 22.04** (GNU/Linux 5.15.167.4-microsoft-standard-WSL2 x86_64) running on a **2-core laptop**  
- **10-core MacBook** with an **Intel Core i7** on the **PACE Cluster**  

## Tools Used
- **Glimmer version 3.02**: A gene prediction tool optimized for prokaryotic genomes.
- **eggNOG-mapper DIAMOND database**: A high-performance sequence aligner used for homology searches.
- **gffread version 0.12.7**: A tool for processing GFF files and extracting sequences.
- **transeq**: A tool from the EMBOSS version 6.6.0​ package to translate _cds.fasta files to _protein.fasta files for input into the DIAMOND database.
  
## Input Files
- **Genome Assemblies**: The input `.fasta` files were assembled using **SKESA** and processed with **Trimmomatic** by Team D1.
- **Reference Genome Model**: A `.icm` file was generated using the **Campylobacter jejuni** reference genome from NCBI for training Glimmer3.

## Workflow
The input file was trained on the **GCF_000009085.1 Campylobacter jejuni** reference genome.  

1. **Gene Prediction with Glimmer3**  
   - **Glimmer3** was used to identify coding sequences (CDS) in 34 genome assemblies.  
   - The `.icm` model, trained on the **Campylobacter jejuni** reference genome, was applied to the 34 genomes, producing `.predict` files.  
2. **Conversion of Predictions**
   - The `.predict` files were converted to `.gff` files using a script called `conversion.py`, which is now part of the larger pipeline.
   - The `.gff` files were further processed using **gffread** to extract coding sequences and generate `cds.fasta` files.
   - The `cds.fasta` files were converted to `proteins.fasta` using transeq package from Emboss. 
3. **Protein Homology Search with eggNOG**
   - Predicted gene sequences were processed using eggNOG-mapper.
   - This database is a sizable download around 17GB as well as the Diamond DB which was around 4GB.
   - DIAMOND database was utilized to find homologous proteins and assign functional annotations.
   - The outputs were `.seed_orthologs` and `.annotations files`.
   - These were converted to .tsv files using tsv_conversion.sh that is now part of the larger pipeline.

If you would like to set up this workflow in Conda here is how you set up the environments.

## Glimmer General Steps

To set up a Conda environment for Glimmer, follow these steps:

1. Create a new Conda environment:

   ```bash
   conda create -n glimmer_env -y
   conda activate glimmer_env
   conda install -c bioconda glimmer gffread emboss

2. Build ICM with reference

    ```bash
   gunzip -v GCF_000009085.1_ASM908v1_genomic.fna.gz
   long-orfs -n -t 1.15 GCF_000009085.1_ASM908v1_genomic.fna type_strain_genome.longorfs
    extract -t GCF_000009085.1_ASM908v1_genomic.fna type_strain_genome.longorfs > type_strain_genome.train

3. Run Glimmer

   ```bash
   glimmer3 -o30 -g150 -t50 sample type_strain_genome.icm sample_output

4. After intermediate steps you can use use eggNOG DIAMOND database to run proteins.fasta samples

## eggNOG General Steps

To set up a Conda environment for eggNOG, follow these steps:

1. Create a new Conda environment:

   ```bash
   conda create --name eggnogenv -y
   conda activate eggnogenv
   conda install -c bioconda eggnog-mapper

2. Download eggNOG database and the DIAMOND database

   ```bash
   download_eggnog_data.py --data_dir ~/total_input_sequences -y #download diamond database as well
   emapper.py --data_dir ~/total_input_sequences -i ~/total_input_sequences/sample_proteins.fasta -o sample_annotations --cpu 4 -m diamond #update directory as needed

3. Post-processing to .tsv format (optional)

    ```bash
    #Extract the header
    grep '^#query_name' sample.emapper.annotations > sample.emapper.annotations.tsv
    # Extract non-comment lines and append
    grep -v '^#' sample.emapper.annotations >> sample.emapper.annotations.tsv

These general steps were adapted to the Docker pipeline script. 

## System Requirements
- Glimmer3 installed and configured
- eggNOG-mapper installed with DIAMOND database 
- gffread and EMBOSS

## Results
The pipeline successfully identified protein homologs across 34 genomes, providing insights into gene function and evolutionary relationships.

## References
- [Glimmer3 Documentation](https://ccb.jhu.edu/software/glimmer/)
- [eggNOG-mapper Documentation](http://eggnog-mapper.embl.de/)
- [DIAMOND Database](https://github.com/bbuchfink/diamond)
- [gffread Documentation](https://github.com/gpertea/gffread)

