if ARGV.size < 1
  print("Provide filename\n")
  exit(-1)
end

k = 256
$numOfNums = k * 1024 * 1024
$fileName = ARGV[0]
$reps = 6

def writeUsingFile()
  open($fileName, 'wb') do |writer| 
    (1..$numOfNums).each { |i| writer.putc(i & 0xff) }
  end
end

def readUsingFile()
  open($fileName, 'rb') do |reader| 
    (1..$numOfNums).each { reader.getc() }
  end
  File.delete($fileName)
end

if File.exists?($fileName)
  File.delete($fileName)
end
(read, write) = (1..$reps).collect { 
  time1 = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond)
  writeUsingFile()
  time2 = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond)
  readUsingFile()
  time3 = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond)
  tmp1 = $numOfNums.to_f / 1024 / 1024 * 1e9
  readTime = tmp1 / (time3 - time2)
  writeTime = tmp1 / (time2 - time1)
  print("#{readTime}, #{writeTime}\n")
  STDOUT.flush
  [readTime, writeTime]
}[1..$reps].inject([0, 0]) { |x, y| [x[0] + y[0], x[1] + y[1]] }
tmp1 = $reps - 1
print "Bytes: #{$numOfNums / 1024 / 1024} MiB, ReadRate: #{read / tmp1} MB/s, WriteRate: #{write / tmp1} MB/s"
