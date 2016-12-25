#include <iostream>
#include <cmath>
using namespace std;

int main(int argc,char* argv[])
{
    long n1,n2,a;
    int i;
    cout<<"Please input narcissistic number digit："<<endl;
    cin>>i;
    for(n1=pow(10,i-1);n1<pow(10,i);n1++)
    {
        n2=0;
        for(int j=0; j<i; j++)
        {
            a=pow(10,j);
            a=n1/a;
            a=a%10;
            a=pow(a,i);
            n2=n2+a;
        }
        if(n1==n2)
           cout<<n1<<endl;
    }
    return 0;
}
