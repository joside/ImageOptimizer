#!/bin/bash

SIZEBEFORE=`du -s $1`

if type -P ffmpeg &>/dev/null; then
  echo "Running ffmpeg"
  for GIF in $(find $1 -type f -name \*.gif);
  do
    TMPFILE=$(mktemp)
    echo "Processing ffmpeg for $GIF "
    ffmpeg -i $GIF -movflags faststart -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" $TMPFILE.mp4
    mv -f $TMPFILE.mp4 $GIF.mp4
  done
else
  echo 'ffmpeg not found. Please install ffmpeg.';
fi

if type -P pngcrush &>/dev/null; then
  echo 'Running pngcrush';
  for PNG in $(find $1 -type f -name \*.png);
  do
    TMPFILE=$(mktemp)
    echo "Processing pngcrush for $PNG"
    pngcrush -reduce -brute $PNG $TMPFILE
    mv -f $TMPFILE $PNG
  done
else
  echo 'pngcrush not found. Please install pngcrush.';
fi

if type -P jpegtran &>/dev/null; then
  echo 'Running jpegtran';
  for JPG in $(find $1 -type f -name \*.jpg);
  do
    TMPFILE=$(mktemp)
    echo "processing jpegtran for $JPG";
    jpegtran -outfile $TMPFILE -copy none -optimize -progressive "$JPG";
    mv -f $TMPFILE $JPG;
  done;
else
  echo 'jpegtran not found. Please install libjpeg.';
fi

SIZEAFTER=`du -s $1`

echo "Finished optimizing";
echo "Size before: $SIZEBEFORE";
echo "Size after: $SIZEAFTER";
