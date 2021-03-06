# OrthoTE-pipeline
  Pipeline for detecting putative orthologous TE insertions in assemblies of related species

### Dependencies:

  - Biopython
  - NCBI blast
  - bedtools

### Before using:

  - Open OtrhoLTRpileline_P2A.sh script and set the paths of the scripts folder, annotation files and blast databases (lines 11-30)
  - The 3rd field of gff files must have the LTR name using this format: LTR_retro1, LTR_retro2, etc ...

### Usage: 

    bash OtrhoLTRpileline_P2A.sh flank_size annotation_file.gff
    
### Results:

-  Final_summary.txt --> List of all ortho_TE candidates, along with the length between the two flank matches. (Identify empty elements were length < 100 bp)

-  overlapping_annotation.txt --> List of ortho_TE candidates whose internal sequence overlaps with an annotated element (Full-length conserved elements)

-  NON_overlapping_matching_repbase.txt -->  ortho_TE candidates that don't overlap with annotation, but show similarity to repbase elements (putative truncated elements in the target species)

-  IGVfiles ---> In this folder you can find several files ready to display in IGV using the target species genome

-  parse_output_P2A.sh can be used to further classify the output (open the script and change the paths if neccesary)


