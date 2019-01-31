import java.io.{BufferedInputStream, BufferedOutputStream, FileInputStream, FileOutputStream}
import java.nio.file.{Files, Paths}

if (args.length < 1) {
  println("Provide filename")
  System.exit(-1)
}

val k = 256 
val numOfNums = k * 1024 * 1024
val fileName = args(0)
val reps = 6

def writeUsingFile(): Unit = {
  val writer = new BufferedOutputStream(new FileOutputStream(fileName))
  try {
    1 to numOfNums foreach { x => writer.write(x & 0xff) }
  } finally
    writer.close
}

def readUsingFile(): Unit = {
  var t = 0
  val reader = new BufferedInputStream(new FileInputStream(fileName))
  try {
    1 to numOfNums foreach { _ => reader.read ; t += 1 }
  } finally
    reader.close
  assert(t >= numOfNums)
  Files.delete(Paths.get(fileName))
}

Files.deleteIfExists(Paths.get(fileName))
val (read, write) = 1 to reps map { _ =>
  val time1 = System.nanoTime()
  writeUsingFile()
  val time2 = System.nanoTime()
  readUsingFile()
  val time3 = System.nanoTime()
  val tmp1 = numOfNums / 1024 / 1024 * 1e9
  val readTime = tmp1 / (time3 - time2)
  val writeTime = tmp1 / (time2 - time1)
  println(s"$readTime $writeTime")
  (readTime, writeTime)
} drop 1 reduce { (x, y) => ((x._1 + y._1), (x._2 + y._2)) }
val tmp1 = reps -1
println(s"Bytes: ${numOfNums / 1024 / 1024} MiB, ReadRate: ${read / tmp1} MB/s, WriteRate: ${write / tmp1} MB/s")
