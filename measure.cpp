#include <chrono>
#include <fstream>
#include <iostream>
using namespace std;

int k = 256;
int numOfNums = k * 1024 * 1024;
int reps = 6;

void writeUsingFile(string fileName) {
  ofstream writer(fileName, ios_base::binary);
  for (int i = 1; i <= numOfNums; ++i)
    writer << (uint8_t) (i & 0xff);
}

void readUsingFile(string fileName) {
  ifstream reader(fileName, ios_base::binary);
  uint8_t c;
  for (int i = 1; i <= numOfNums; ++i) 
    reader >> c;
  remove(fileName.c_str());
}

int main(int argc, char* argv[]) {
  if (argc < 2) {
    cerr << "Provide filename" << endl;
    exit(-1);
  }
  string fileName(argv[1]);

  remove(fileName.c_str());

  float read = 0;
  float write = 0;
  for (int i = 1; i <= reps; i++) {
    auto time1 = chrono::system_clock::now();
    writeUsingFile(fileName);
    auto time2 = chrono::system_clock::now();
    readUsingFile(fileName);
    auto time3 = chrono::system_clock::now();
    auto tmp1 = numOfNums / 1024 / 1024 * 1e9;
    auto diff1 = chrono::duration_cast<chrono::nanoseconds>(time3 - time2).count();
    auto readTime = tmp1 / diff1;
    auto diff2 = chrono::duration_cast<chrono::nanoseconds>(time2 - time1).count();
    auto writeTime = tmp1 / diff2;
    cout << readTime << ' ' << writeTime << endl;
    if (i != 1) {
      read += readTime;
      write += writeTime;
    }
  } 
  int tmp1 = reps - 1;
  cout << "Bytes: " << numOfNums / 1024 / 1024 << " MiB, ReadRate: " << \
    read / tmp1 << "MB/s, WriteRate: " << write / tmp1 << " MB/s" << endl;
}
