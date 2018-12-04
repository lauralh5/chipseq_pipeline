#$ -S /bin/bash
#$ -cwd
#$ -j yes
#$ -V

SAMPLE_DIR=$1
SAMPLE_FILE=$2
SAMPLE_TYPE=$3
WORK_DIR=$4
MAIN_FOLDER=$5
INS_FOLDER=$6

## Accession to the samples folders

cd ${SAMPLE_DIR}
cp ${SAMPLE_FILE} ${SAMPLE_TYPE}.fq.zip
unzip ${SAMPLE_TYPE}.fq.zip

## Mapping short reads to the reference genome
bowtie -S -v 2 --best --strata -m 1 ../../genome/index ${SAMPLE_TYPE}.fq > ${SAMPLE_TYPE}.sam

## Reading and writing on the blackboard
echo ${SAMPLE_TYPE} DONE >> ../../log/blackboard
SAMPLE_DONE=$(wc -l ../../log/blackboard | awk '{ print $1 }')

if [ ${SAMPLE_DONE} -eq 2 ]
then
	qsub -N peakscalling -o peakscalling ${INS_FOLDER}/peaks_calling.sh ${WORK_DIR} ${MAIN_FOLDER} ${INS_FOLDER}
fi


