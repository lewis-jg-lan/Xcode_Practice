//
//  main.cpp
//  test
//
//  Created by Linda8_Yang on 16/12/19.
//  Copyright © 2016年 Linda8_Yang. All rights reserved.
//

#include "iostream"
#include <string>
#include <fstream>
using namespace std;

void read() { cout << "read()\n"; }
void sort() { cout << "sort()\n"; }
void compact() { cout << "compact()\n"; }
void write() { cout << "write()\n"; }

int main(int argc, const char * argv[])
{
    ofstream outfile("test.c");
    if (!outfile) {
        cerr << "unable to open the file!"<<endl;
    }
    ifstream infile("test.c");
    if (!infile)
    {
        cerr<<"fail"<<endl;
    }
    
    read();
    sort();
    compact();
    write();
    
    int test1 = 1, test2 = 2;
    cout<< test2 + test1 << '\n';
    
    string word;
    cout << "please enter a string:";
    while(infile >> word)
        outfile << "word read is:" << word << endl;
    cout <<"OK,bye!";
    std::cout << "Hello, World!\n";
    return 0;
}

