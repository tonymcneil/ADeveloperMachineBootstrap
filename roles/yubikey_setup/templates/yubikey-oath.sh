#!/usr/bin/env bash

# first time use run: ykman oath remember-password
OUTPUT=`ykman oath code "${1}"`
CODE=`echo $OUTPUT | awk '{print $NF}'`

if [ $? -eq 0 ]; then
  echo "$OUTPUT code in clipboard"
  echo $CODE | xsel -b
else
  echo "FAILED! $OUTPUT"
fi
