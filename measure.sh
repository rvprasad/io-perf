#!/bin/bash

compute="laptop"
device="usb3-exfat"
file="/media/<user>/Portable/temp/outfile.tmp"
time scala measure.scala $file 2>&1 | tee $compute-$device-scala.log
time ./measure-c++ $file 2>&1 | tee $compute-$device-c++.log
time ./measure-go $file 2>&1 | tee $compute-$device-go.log
time python3.7 measure.py $file 2>&1 | tee $compute-$device-python.log
time ruby measure.rb $file 2>&1 | tee $compute-$device-ruby.log
device="ssd-ext4"
file="/tmp/outfile.tmp"
time scala measure.scala $file 2>&1 | tee $compute-$device-scala.log
time ./measure-c++ $file 2>&1 | tee $compute-$device-c++.log
time ./measure-go $file 2>&1 | tee $compute-$device-go.log
time python3.7 measure.py $file 2>&1 | tee $compute-$device-python.log
time ruby measure.rb $file 2>&1 | tee $compute-$device-ruby.log
device="sata-ext4"
file="/mnt/Data1/sort-input/temp/outfile.tmp"
time scala measure.scala $file 2>&1 | tee $compute-$device-scala.log
time ./measure-c++ $file 2>&1 | tee $compute-$device-c++.log
time ./measure-go $file 2>&1 | tee $compute-$device-go.log
time python3.7 measure.py $file 2>&1 | tee $compute-$device-python.log
time ruby measure.rb $file 2>&1 | tee $compute-$device-ruby.log
