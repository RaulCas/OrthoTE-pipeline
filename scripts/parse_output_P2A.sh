
#-------------------------------------------------   README    ------------------------------------------------------------------------------
# This script sumarizes the output of OtrhoLTRpileline_P2A.sh, by intersecting putative orthoLTRs with the anotations of the target species
#
# - Before use:
# 	1- Create internal_noempty.bed (ortho_internal.bed excluding those with L < 100bp) 
# 	2- Change paths of annotations depending wether you are doing Peach top almond (P2A) dor almond to peach (A2P)
# - Usage:
#       bash parse_output_P2A.sh
# - Outputs:
#	"overlapping" files in bed format
#---------------------------------------------------------------------------------------------------------------------------------------------

#1- intersect with LTRharvest:

bedtools intersect -wa -e -f 0.7 -F 0.7 -a internal_noempty.bed -b /home/rcastanera/Documents/CRAG/Anotation/TE_orthology_files/almond_setA_harvest_170529_TEorthology.gff | sort | uniq > overlapping_LTRharvest.bed;

bedtools intersect -v -wa -e -f 0.7 -F 0.7 -a internal_noempty.bed -b /home/rcastanera/Documents/CRAG/Anotation/TE_orthology_files/almond_setA_harvest_170529_TEorthology.gff | sort | uniq > noLTRharvest.bed;

#2 Intersect with setB:

bedtools intersect -wa -e -f 0.7 -F 0.7 -a noLTRharvest.bed -b /home/rcastanera/Documents/CRAG/Anotation/ltr/setB/Almond_setB_notSetA.bed | sort | uniq > overlapping_setB.bed;

bedtools intersect -v -wa -e -f 0.7 -F 0.7 -a noLTRharvest.bed -b /home/rcastanera/Documents/CRAG/Anotation/ltr/setB/Almond_setB_notSetA.bed | sort | uniq > noLTR_nosetB.bed;


#3- Intersect with soloLTR: more stringet, reciprocal overlap of 50%

bedtools intersect -wa -r -f 0.5 -a noLTR_nosetB.bed -b /home/rcastanera/Documents/CRAG/Anotation/ltr/soloLTR/solo_almond_noSetB_notNested.MERGE.CLUSTERS.bed | sort | uniq > overlapping_soloLTR.bed;

bedtools intersect -v -wa -r -f 0.5 -a noLTR_nosetB.bed -b /home/rcastanera/Documents/CRAG/Anotation/ltr/soloLTR/solo_almond_noSetB_notNested.MERGE.CLUSTERS.bed | sort | uniq > noLTR_nosetB_nosoloLTR.bed; 


#4- Intersect all noLTRharvest with truncated

bedtools intersect -wa -e -f 0.7 -F 0.7 -a noLTR_nosetB_nosoloLTR.bed -b /home/rcastanera/Documents/CRAG/Anotation/ltr/truncated/almond_trunc_15_to_100_w_clusters.bed | sort | uniq > overlapping_truncated.bed

bedtools intersect -v -wa -e -f 0.7 -F 0.7 -a noLTR_nosetB_nosoloLTR.bed -b /home/rcastanera/Documents/CRAG/Anotation/ltr/truncated/almond_trunc_15_to_100_w_clusters.bed | sort | uniq > noLTR_nosetB_nosoloLTR_notrunc.bed; 

#5- Intersect with REPET

bedtools intersect -wa -e -f 0.3 -F 0.3 -a noLTR_nosetB_nosoloLTR_notrunc.bed -b /home/rcastanera/Documents/CRAG/Anotation/repet/Almond_REPET_verified.gff3 | sort | uniq > overlapping_repet.bed;

bedtools intersect -v -wa -e -f 0.3 -F 0.3 -a noLTR_nosetB_nosoloLTR_notrunc.bed -b /home/rcastanera/Documents/CRAG/Anotation/repet/Almond_REPET_verified.gff3 | sort | uniq > noLTR_nosetB_nosoloLTR_notrunc_norepet.bed






