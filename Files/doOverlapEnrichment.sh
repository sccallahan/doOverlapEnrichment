#!/usr/bin/env bash

#######################################################
## Author: Carson Callahan
## Purpose: Automate ChromHMM OverlapEnrichment
## Date: 2019-01-14
## Notes: uses the segments.bed file from ChromHMM
#######################################################

## Arguments
bed_for_segment=$1 # the x-axis sample (one being mapped to)
folder=$2 # folder for segment files
segments_bed=$3 # the y-axis sample
prefix=$4 # what you're going to call the output from ChromHMM
chromhmm_outputs=$5 # folder for holding chromhmm output files

## Code
# need to include FNR >1 to skip first line of .bed file
# need single quotes around 'F\t'
echo "Segmenting BED file, this might take a minute..."
#segment BED file that will make X axis
if awk '-F\t' '{print >> $4;close($4)}' $bed_for_segment # add FNR > 1 before print for some weird beds
then
	echo "BED file segmented!"
else
	echo "Unable to segment BED, check error messages"
	exit 1
fi
# Make folder for holding segmented BEDs
mkdir ./$folder
# Move segmented BEDS into the folder
# need backticks around the mv "filname" so the output is passed as the argument
if mv `ls|egrep '^E[0-9]+$'` ./$folder
then
	echo "Segmented files moved to directory!"
else 
	echo "Failed to move segmented files into folder. Ensure files are numbers 1-n and "$folder" exists"
	exit 1
fi
cd ./$folder
# file_list=`ls *`
# echo "$file_list"
echo "Renaming files..."
COUNTER=1
for file in *; do
	if [ "${#file}" -eq 2 ]
		then
			echo "renamed file "$COUNTER""
			mv ./"$file" "${file/E/0}"
			let COUNTER=COUNTER+1
		else
			echo "renamed file "$COUNTER""
			mv ./"$file" "${file/E/}"
			let COUNTER=COUNTER+1
	fi
done
cd ..
# Make folder to hold ChromHMM output
mkdir ./$chromhmm_outputs
echo "Making chromatin state transition files..."
# ChromHMM OverlapEnrichment to make chromatin state transition files
if java -mx4000M -jar ~/anaconda3/share/chromhmm-1.15-0/ChromHMM.jar OverlapEnrichment $segments_bed $folder $prefix # maybe include full path to ChromHMM.jar
then
	echo "Chromatin State Transitions complete!"
else
	echo "OverlapEnrichment failed, check error messages."
fi
# Move ouputs into folder as before
mv *$prefix* ./$chromhmm_outputs
echo "Script complete! Check "$chromhmm_outputs" for output."
