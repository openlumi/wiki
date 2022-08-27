#!/bin/bash

function generate_html_index() {
  INDEX_FILE=$1/index.md
  CONTENT='

# [(releases)](/releases/) / [(..)](../)  /

| File Name  | File Size  | Date  |
|!---|---!|---|'
  for filepath in `find "$1" -maxdepth 1 -mindepth 1  -type d \( ! -iname ".*" \) | sort`; do
    base_path=`basename "$filepath"`
    CONTENT+='| ['$base_path']('$base_path') | | |'
  done

  for i in `find "$1" -mindepth 1 -maxdepth 1 \
      -type f \( ! -iname ".*" ! -iname "index.md" \) | sort`; do

      file=`basename "$i"`
      file_size=`du -h "$i" | cut -f1`
      file_modify_time=`git log -1 --format=%ci -- $i`

      CONTENT+='| ['$file'](./'$file') | '$file_size' | '$file_modify_time' |'
  done

  echo $CONTENT > $INDEX_FILE
  echo $INDEX_FILE
}

for directory in `find "$1"  -type d| sort`; do
  echo $directory
  generate_html_index $directory
done
