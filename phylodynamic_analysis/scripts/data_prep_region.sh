# multiple sequence alignment file prep for beauti
# after completing nextstrain workflow through 'mask' steps,
# make sure there are no duplicate strain names prior to running
# usage:
# ./data_prep.sh


mkdir ../results/beauti
cp ../data/metadata-that-has-sequences_combined_hct.tsv ../results/beauti/
cp ../results/aligned_temporal_kc.fasta ../results/beauti/
cd ../results/beauti

#make new strain name col with format name_hct_date
awk -F"\t" 'OFS="\t" {$1=$2"_"$32"_"$7; print}' metadata-that-has-sequences_combined_hct.tsv > meta.tsv

#remove spaces from strain names
awk -F"\t" 'OFS="\t" {gsub(/[[:blank:]]/, "",$1); print}' meta.tsv > tmp && mv tmp meta.tsv

#rename column as 'strain'
awk -F"\t" 'OFS="\t" {sub(/strain_region_date/,"strain",$1); print}' meta.tsv > tmp && mv tmp meta.tsv

#make key,value file kv.txt with 1st col 'strain', 2nd col 'strain_hct_date'
awk 'NR==1{OFS="\t";save=$2;print $2,$1}NR>1{print $2,$1,save}' meta.tsv > kv.txt
awk '!($3="")' kv.txt

#replace old strain names in alignment .fasta  with new strain names
cat aligned_temporal_kc.fasta | seqkit replace --ignore-case --kv-file "kv.txt" --pattern "^(.+)" --replacement "{kv}" > align_temporal_kc.fasta

#remove the outgroup for beast analyses
#cat align.fasta | awk '/>MPXV_USA_2021_MD_NorthAmerica_2021-11-04/ {getline; while(!/>/) {getline}} 1' > beauti.fasta


