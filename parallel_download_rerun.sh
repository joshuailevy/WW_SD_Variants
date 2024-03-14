#!/bin/bash
my_func() {
    sample=$1

    echo $sample
    if [[ ! -f "outputs/${sample}.demixed" ]]; then
	sam-dump ${sample} | samtools view -bS - > "bams/${sample}.bam"

	samtools sort -o "bams/${sample}.sorted.bam" "bams/${sample}.bam"
	samtools index "bams/${sample}.sorted.bam" 
	# ivar trim -x 4 -e -m 80 -i "bams/${sample}.sorted.bam" -b ${bedfile} -p "trimmed/${sample}.trimmed"
	rm "bams/${sample}.bam"

	# samtools sort -o "trimmed/${sample}.trimmed.sorted.bam" "trimmed/${sample}.trimmed.bam"
	# samtools index "trimmed/${sample}.trimmed.sorted.bam"
	freyja variants "bams/${sample}.sorted.bam" --variants "vars/${sample}.tsv" --depths "depths/${sample}.depth" --ref data/NC_045512_Hu-1.fasta --refname "2019-nCoV" --annot data/NC_045512_Hu-1.gff
	freyja demix "vars/${sample}.tsv" "depths/${sample}.depth" --output "outputs/${sample}.demixed" # --barcodes usher_barcodes_with_gisaid.csv
	rm "bams/${sample}.sorted.bam"
	fi
}

export -f my_func

data='samples_names.txt'
#skip the header row. 
tail -n +2 wastewater_ncbi.csv | cut -d, -f1 > $data
# parallel -j 36 my_func ::: ../variants/* ::: ../depths/ ::: ../standard-outputs/
parallel -j 25 -a $data my_func
