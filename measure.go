package main

import (
	"bufio"
	"fmt"
	"os"
	"time"
)

func writeUsingFile(fileName string, numOfNums int) {
	file, _ := os.OpenFile(fileName, os.O_CREATE|os.O_WRONLY, 0600)
	defer file.Close()
	writer := bufio.NewWriter(file)
	for i := 1; i <= numOfNums; i++ {
		writer.WriteByte(byte(i & 0xff))
	}
}

func readUsingFile(fileName string, numOfNums int) {
	file, _ := os.Open(fileName)
	defer file.Close()
	reader := bufio.NewReader(file)
	for i := 1; i <= numOfNums; i++ {
		reader.ReadByte()
	}

	os.Remove(fileName)
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Provide filename")
		os.Exit(-1)
	}

	k := 256
	numOfNums := k * 1024 * 1024
	fileName := os.Args[1]
	reps := 6

	if os.Remove(fileName) != nil {
		// ignore
	}

	var read float32 = 0.0
	var write float32 = 0.0
	for i := 1; i <= reps; i++ {
		time1 := time.Now()
		writeUsingFile(fileName, numOfNums)
		time2 := time.Now()
		readUsingFile(fileName, numOfNums)
		time3 := time.Now()
		tmp1 := float32(numOfNums/1024/1024) * 1e9
		diff1 := time3.Sub(time2)
		readTime := tmp1 / float32(diff1)
		diff2 := time2.Sub(time1)
		writeTime := tmp1 / float32(diff2)
		fmt.Println(readTime, writeTime)
		if i != 1 {
			read += float32(readTime)
			write += float32(writeTime)
		}
	}

	tmp1 := reps - 1
	fmt.Println("Bytes:", numOfNums/1024/1024, "MiB, ReadRate:",
		read/float32(tmp1), "MB/s, WriteRate:", write/float32(tmp1), "MB/s")
}
