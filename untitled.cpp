

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int narcissistic( int n )  
{

    int hundred = n/100;
    int ten = (n/10)%10;
    int one = n%10;

    int value = pow(hundred,3)+pow(ten,3)+pow(one,3)
    if (value == n)
    {
    	return 0;
    }
    else
    	return 1;
}

int main()
{
	for (int i = 100; i < 1000; ++i)
	{
		if (narcissistic(i) == 0)
		{
			printf("%i ", i);
		}
	}
	printf("\n");
}
