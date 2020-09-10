#!/bin/bash
# Created by Alexander aka BioDranik <me@alex.bio> in Minsk, Belarus
#edited.
set -eu

if [ $# -lt 1 ]; then
  echo "Usage: $0 <path_to_directory_where_to_test_read_and_write_speed>"
  exit 1
fi

SD_DIR=$1
FILENAME="$SD_DIR/USBdisktest.tmp"
SIZE=10 # in KB
SIZEBYTE=$((SIZE*1024))
BLOCKSZ=(512 1024 4096 10485760)
BS=1

WRITE_FILE_COMMAND="dd if=/dev/zero of=$FILENAME bs=$BS count=$SIZEBYTE oflag=dsync"

READ_FILE_COMMAND="dd of=/dev/zero if=$FILENAME bs=$BS count=$SIZEBYTE oflag=dsync iflag=nocache"

WriteFile() {
  local blocks=${#BLOCKSZ[@]}

  for (( b=1; b<$blocks; b++ ))
  do
    BS=BLOCKSZ[b]
    echo "-------------------------------"
    echo "Writing ${SIZE}KB file Block Size: ${BLOCKSZ[b]}B..."
    RES=$({ $WRITE_FILE_COMMAND >/dev/null; } 2>&1)
    echo ${RES/#*$'\n'} 
    #echo $RES
  done
}

ReadFile() {
  local blocks=${#BLOCKSZ[@]}

  for (( b=1; b<$blocks; b++ ))
  do
    BS=BLOCKSZ[b]
    echo "-------------------------------"
    echo "Reading ${SIZE}KB file Block Size: ${BLOCKSZ[b]}B..."
    RES=$({ $READ_FILE_COMMAND >/dev/null; } 2>&1)
    echo ${RES/#*$'\n'}
    #echo $RES
  done
}


WriteFile
# Always delete created file on exit.
trap "rm $FILENAME" 0
ReadFile
