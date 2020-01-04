MODEL=${MODEL:- "models/DBLP"}
#TEXT_TO_SEG=${TEXT_TO_SEG:-test/test.txt}
TEXT_TO_SEG=${TEXT_TO_SEG:-"$1"}
TIMESTAMP=${TIMESTAMP:-"$2"}
echo ${TIMESTAMP}
HIGHLIGHT_MULTI=${HIGHLIGHT_MULTI:- 0.5}
HIGHLIGHT_SINGLE=${HIGHLIGHT_SINGLE:- 0.8}

#echo "$1"

SEGMENTATION_MODEL=${MODEL}/segmentation.model
TOKEN_MAPPING=${MODEL}/token_mapping.txt

ENABLE_POS_TAGGING=1
THREAD=10

green=`tput setaf 2`
reset=`tput sgr0`

echo ${green}===Compilation===${reset}

COMPILE=${COMPILE:- 1}
if [ $COMPILE -eq 1 ]; then
    bash compile.sh
fi

mkdir -p tmp
mkdir -p ${MODEL}

### END Compilation###

echo ${green}===Tokenization===${reset}

TOKENIZER="-cp .:tools/tokenizer/lib/*:tools/tokenizer/resources/:tools/tokenizer/build/ Tokenizer"
TOKENIZED_TEXT_TO_SEG=tmp/${TIMESTAMP}tokenized_text_to_seg.txt
CASE=tmp/${TIMESTAMP}case_tokenized_text_to_seg.txt


echo -ne "Current step: Tokenizing input file...\033[0K\r"
time java $TOKENIZER -m direct_test -i $TEXT_TO_SEG -o $TOKENIZED_TEXT_TO_SEG -t $TOKEN_MAPPING -c N -thread $THREAD

LANGUAGE=`cat ${MODEL}/language.txt`
echo -ne "Detected Language: $LANGUAGE\033[0K\n"

### END Tokenization ###

echo ${green}===Part-Of-Speech Tagging===${reset}
 
if [ ! $LANGUAGE = "JA" ] && [ ! $LANGUAGE = "CN" ]  && [ ! $LANGUAGE = "OTHER" ]  && [ $ENABLE_POS_TAGGING -eq 1 ]; then
	RAW=tmp/raw_${TIMESTAMP}tokenized_text_to_seg.txt # TOKENIZED_TEXT_TO_SEG is the suffix name after "raw_"
	export THREAD LANGUAGE RAW TIMESTAMP
	bash ./tools/treetagger/pos_tag.sh
	# echo "pos_tag.sh -------------------------------------------------------------------- already ran"
	mv tmp/${TIMESTAMP}pos_tags.txt tmp/${TIMESTAMP}pos_tags_tokenized_text_to_seg.txt
fi

POS_TAGS=tmp/${TIMESTAMP}pos_tags_tokenized_text_to_seg.txt

### END Part-Of-Speech Tagging ###

echo ${green}===Phrasal Segmentation===${reset}

if [ $ENABLE_POS_TAGGING -eq 1 ]; then
	time ./bin/segphrase_segment \
        --pos_tag \
        --thread $THREAD \
        --timestamp $TIMESTAMP \
        --model $SEGMENTATION_MODEL \
		--highlight-multi $HIGHLIGHT_MULTI \
		--highlight-single $HIGHLIGHT_SINGLE
else
	time ./bin/segphrase_segment \
        --thread $THREAD \
        --timestamp $TIMESTAMP \
        --model $SEGMENTATION_MODEL \
		--highlight-multi $HIGHLIGHT_MULTI \
		--highlight-single $HIGHLIGHT_SINGLE
fi

### END Segphrasing ###

echo ${green}===Generating Output===${reset}
java $TOKENIZER -m segmentation -i $TEXT_TO_SEG -segmented tmp/${TIMESTAMP}tokenized_segmented_sentences.txt -o ./${TIMESTAMP}segmentation.txt -tokenized_raw tmp/raw_${TIMESTAMP}tokenized_text_to_seg.txt -tokenized_id tmp/${TIMESTAMP}tokenized_text_to_seg.txt -c N

### END Generating Output for Checking Quality ###
