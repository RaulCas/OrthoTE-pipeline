# OrthoTE-pipeline
## Pipeline for detecting putative orthologous TE insertions in assemblies of related species

### DEPENDENCIES:

  - Biopython
  - NCBI blast
  - bedtools

### BEFORE USING:

  - Open OtrhoLTRpileline.sh script and set the paths of your annotation files and blast databases (line 11-30)
  - The 3rd field of gff files must have the LTR name using this format: LTR_retro1, LTR_retro2, etc ...

### USAGE: 

    bash OtrhoLTRpileline.sh flank_size annotation_file.gff


