#========================================================================
# Tool to detect putative orthologous insertions between two genomes
# 
# USAGE: OtrhoLTRpileline.sh flank_size ggf_file
#
#========================================================================


# ------------------------------------ Set this BEFORE running the pipeline ---------------------------------

# Define full paths to necessary files:

scripts_folder="/home/rcastanera/Documents/CRAG/TE_orthology/Raul/scripts"     # Without the last '/'
repbase_db="/home/rcastanera/Documents/localizaTE/testdb"                      # Peptides Database for blastx

# Species 1 (here Peach):

peach_genome_file="/home/rcastanera/Documents/CRAG/Anotation/genomefilesbed/peach_genome.txt"  # bedtools genome file, NOT fasta genome file
peach_fasta_file="/home/rcastanera/Documents/CRAG/Anotation/genomes/Prunus_persica_V2-pseudo.fa"
LTRharvest_annot_peach="/home/rcastanera/Documents/CRAG/Anotation/TE_orthology_files/peach_setA_harvest_170529_TE_orthology.gff"
soloLTR_annot_peach="/home/rcastanera/Documents/CRAG/Anotation/ltr/soloLTR/solo_almond_noSetB_notNested.MERGE.CLUSTERS.bed"
peach_blastdb="/home/rcastanera/Documents/CRAG/Anotation/Blast_db/Ppersica"


# Species 2 (here Almond):

almond_genome_file="/home/rcastanera/Documents/CRAG/Anotation/genomefilesbed/Pdulcis_genomefile.txt" # bedtools genome file, NOT fasta genome file
almond_fasta_file="/home/rcastanera/Documents/CRAG/Anotation/genomes/pdulcis7.scaffolds.fa"
LTRharvest_annot_almond="/home/rcastanera/Documents/CRAG/Anotation/TE_orthology_files/almond_setA_harvest_170529_TEorthology.gff"
soloLTR_annot_almond="/home/rcastanera/Documents/CRAG/Anotation/ltr/soloLTR/solo_almond_noSetB_notNested.MERGE.CLUSTERS.bed"
almond_blastdb="/home/rcastanera/Documents/CRAG/Anotation/Blast_db/Pdulcis"

#---------------------------------------- PROGRAM -------------------------------------------------------------

################### STEP1: Identification of OrthoLTR sites

# Extract flanks: $1 gff file

bedtools flank -i $2 -g $peach_genome_file -b $1 > LTR_flanks.gff;
printf 'Flanks extracted..\n'

# Rename LTR flank IDs (Flanks _1 and _2)

python $scripts_folder/rename.py LTR_flanks.gff > LTR_flanks_renamed.gff;
printf 'Flanks renamed..........\n'

# Extractfasta

bedtools getfasta -fi $peach_fasta_file -bed LTR_flanks_renamed.gff -name+ > Peach_LTR_flanks.fasta;
printf 'Extract flanks in fasta format..\n'

printf 'Running blastn ..........................\n'

# Run blastn against Species 2 -- only best hits are retrieved

blastn -task blastn -query Peach_LTR_flanks.fasta -db $almond_blastdb -evalue 0.0000000001 -out blast.out -outfmt 6 -max_target_seqs 1 -max_hsps 1 -num_threads 6;

printf 'Checking concordant matches ....................\n'

# join both hits in one line and detect those mapping to the same scaffold under a reasonable length

less blast.out | awk '{FS="_"} {print$1"_"$2}' | sort | uniq > LTR_unique_names.txt; 

python $scripts_folder/parse_orthology.py > summary_hits.txt;

while [ ! -f ./summary_hits.txt ]; do sleep 10; done; # wait the file to exist

python $scripts_folder/filter_scaf.py > Final_summary.txt;

while [ ! -f ./Final_summary.txt ]; do sleep 5; done; # wait the file to exist

printf '...FINISHED DETECTION....\n'
printf 'Continue with analysis ..\n'


################### STEP2: Analysis of OrthoLTR sites

# make internal and flank bedfiles

less Final_summary.txt | awk '{print $2"\t"$4"\t"$5"\t"$1";"$7$8}' > orthoLTR_internal.bed;

less Final_summary.txt | awk '{print $2"\t"$3"\t"$4"\t"$1"_1"}' > orthoLTR_lflank.bed;

less Final_summary.txt | awk '{print $2"\t"$5"\t"$6"\t"$1"_2"}' > orthoLTR_rflank.bed;

cat orthoLTR_lflank.bed orthoLTR_rflank.bed | sort -k 1,1 -k2,2n > combined_flanks.bed;

# Intersect internal sequences with the corresponding annotation (in this case SoloLTR):

bedtools intersect -wa -F 0.7 -a orthoLTR_internal.bed -b $soloLTR_annot_almond | sort | uniq > overlapping_annotation.txt;

bedtools intersect -v -wa -F 0.7 -a orthoLTR_internal.bed -b $soloLTR_annot_almond | sort | uniq > NON_overlapping_annotation.bed;

# Classfy noempty: extract fasta and Blastx vs REPBASE database  

bedtools getfasta -fi $almond_fasta_file -bed NON_overlapping_annotation.bed -name+ > NON_overlapping_annotation.fasta;

blastx -task blastx -query NON_overlapping_annotation.fasta -db $repbase_db -evalue 0.0000000001 -out blastx.out -outfmt 6 -max_target_seqs 1 -num_threads 6;

grep 'LTR/' blastx.out | awk '{FS="\t"} {print $1}' | sort | uniq > NON_overlapping_matching_repbase.txt;

# Clean and organize outputs

rm LTR_flanks.gff orthoLTR_rflank.bed orthoLTR_lflank.bed

mkdir IGVfiles

mv combined_flanks.bed orthoLTR_internal.bed IGVfiles/















