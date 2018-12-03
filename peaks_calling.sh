#$ -S /bin/bash
#$ -cwd
#$ -j yes
#$ -V


# Read params

WORK_DIR=$1
MAIN_FOLDER=$2
INS_FOLDER=$3

# Accesss to Results directory

cd $WORK_DIR/$MAIN_FOLDER/results
echo "Access to results folder successful" >> ../log/blackboard

## Peak calling instruction

macs2 callpeak -t $WORK_DIR/$MAIN_FOLDER/samples/chip/chip.sam -c $WORK_DIR/$MAIN_FOLDER/samples/input/input.sam -f SAM --outdir . -n peaks
echo "macs2 called succesfully" >> ../log/blackboard

## Peak Annotation

java -jar $INS_FOLDER/PeakAnnotator.jar -u NDG -p peaks_summits.bed -a ../annotation/annotation.gtf -g all -o .

echo "PeakAnnotator called successfully" >> ../log/blackboard

## Execute R script

Rscript --vanilla $INS_FOLDER/target_genes.R peaks_summits.ndg.bed peaks_summits.overlap.bed target_genes.txt

