#!/bin/bash

in_file=/dev/zero
out_file=/media/<user>/Portable/sort-input/temp/outfile.tmp

for bs in 1 2 4 8 16 32 64 128 256 512 1024 2048 ; do
  let count=128*1024/$bs
  rate=0
  for i in `seq 1 5` ; do
    let rate+=`dd if=$in_file of=$out_file bs=${bs}k count=${count} 2>&1 \
      | grep copied | cut -f10,11 -d' ' | sed -e 's/ MB\/s//' -e 's/\..*//'`
  done
  let rate/=5
  echo "Bytes: $((count * bs / 1024)) MiB, Block Size: $bs KiB, Rate: $rate MB/s"
done

rm $out_file
