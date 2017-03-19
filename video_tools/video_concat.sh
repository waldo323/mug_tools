#!/bin/bash
# concatenate Michigan User group (mug.org) videos for youtube upload
#
# read the *.mp4 files in and below the current working directory
# sort the paths to the files then concatenate them together

if [ ! -f "`pwd`"concatfile.txt ];then
        find "`pwd`" -name "*.MP4"|awk '{print "file " $1}'| sort >>concatfile.txt
fi
TMP_DATA=$(find "`pwd`" -name "*.MP4"|awk '{print "file " $1}'| sort |diff concatfile.txt -)
echo "Check videos to concatenate"

if [ "$TMP_DATA" == "" ]
then
	echo "concatenation file is up to date, no changes needed."
else
	echo "concatenation file is not up do date, moving the current file and creating a new one."
        TMP_DATE=`date +%Y_%m_%d_%H_%M_concatfile.txt`
        mv concatfile.txt `echo $TMP_DATE` 

        find "`pwd`" -name "*.MP4"|awk '{print "file " $1}'| sort >>concatfile.txt
fi

# stat MAH00326.MP4 |awk '/Modify/{print $2}'
VIDEO_DATE=$(find "`pwd`" -name "*.MP4"|stat -|awk '/Modify/{print $2}')
VIDEO_NAME="_mug_video.mp4"
echo "Concatenate videos"
ffmpeg -f concat -safe 0 -i concatfile.txt -c copy $VIDEO_DATE$VIDEO_NAME
echo "Concatenation finished please check the resulting file, $VIDEO_DATE$VIDEO_NAME, before uploading to youtube."
