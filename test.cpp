#include <iostream>
#include <string>
using namespace std;
        
void read() { cout << "read()\n"; }
void sort() { cout << "sort()\n"; }
void compact() { cout << "compact()\n"; }
void write() { cout << "write()\n"; }

int main(int argc, char const *argv[]) 
{
    read();
    sort();
    compact();
    write();

    int test1 = 1, test2 = 2;
    cout<< test2 + test1 << '\n';

    string word;
    cout << "please enter a string:";
    while(cin >> word)
    	cout << "word read is:" << word <<endl;
    cout << "ok,bye!";

    return 0;

}