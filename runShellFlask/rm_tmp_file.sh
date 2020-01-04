TIMESTAMP=${TIMESTAMP:-"$1"}

TOKENIZED_TEXT_TO_SEG=tmp/${TIMESTAMP}tokenized_text_to_seg.txt
RAW=tmp/raw_${TIMESTAMP}tokenized_text_to_seg.txt 
POS_TAGS=tmp/${TIMESTAMP}pos_tags_tokenized_text_to_seg.txt
tokenizedSegmentedSentences=tmp/${TIMESTAMP}tokenized_segmented_sentences.txt
segmentationFile=${TIMESTAMP}segmentation.txt
tempInput=${TIMESTAMP}tempInput.txt

rm ${TOKENIZED_TEXT_TO_SEG}
rm ${RAW}
rm ${POS_TAGS}
rm ${tokenizedSegmentedSentences}
rm ${segmentationFile}
rm ${tempInput}