import os, sys, time

if len(sys.argv) < 2:
    print("Provide filename")
    sys.exit(-1)

k = 256
numOfNums = k * 1024 * 1024
fileName = sys.argv[1]
reps = 6

def writeUsingFile():
  with open(fileName, 'w', encoding='iso8859') as writer: 
    for i in range(1, numOfNums):
      writer.write(chr(i & 0xff))

def readUsingFile():
  with open(fileName, 'r', encoding='iso8859') as reader: 
    for i in range(1, numOfNums):
      reader.read(1)
  os.remove(fileName)

def foo(x):
  time1 = time.perf_counter()
  writeUsingFile()
  time2 = time.perf_counter()
  readUsingFile()
  time3 = time.perf_counter()
  tmp1 = numOfNums / 1024 / 1024 
  readTime = tmp1 / (time3 - time2)
  writeTime = tmp1 / (time2 - time1)
  print("{0} {1}".format(readTime, writeTime))
  sys.stdout.flush()
  return [readTime, writeTime]

if os.path.exists(fileName):
  os.remove(fileName)
tmp1 = [foo(x) for x in range(1, reps + 1)]
read, write = map(sum, zip(*(tmp1[1:])))
tmp2 = reps - 1
print("Bytes: {0} MiB, ReadRate: {1} MB/s, WriteRate: {2}".format(numOfNums / 1024 / 1024, read / tmp2, write / tmp2))
