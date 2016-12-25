//
//  main.m
//  FunctionTest
//
//  Created by Linda8_Yang on 16/12/6.
//  Copyright © 2016年 Linda8_Yang. All rights reserved.
//

#import "AppDelegate.h"

//#define SWAP(x,y) ((x) ^= (y) ^= (x) ^= (y))
//define SWAP(x,y) (x)^=(y)^=(x)^=(y)
//#define SWAP(x,y) {x = x + y; y = x - y; x = x - y;}
#ifndef SWAP
#define SWAP(x,y) {x = x + y; y = x - y; x = x - y;}
#endif

#ifndef COMPARE
#define COMPARE(x,y,z) ((x)>(y)?(x):(y))>(z)?((x)>(y)?(x):(y)):(z)
#endif

int max(int x,int y)
{
    if (x<y) {
        x ^= y;
        y ^= x;
        x ^= y;
    }
    return x;
}

int max2(int *x,int *y)
{
    if (*x<*y) {
        *x ^= *y;
        *y ^= *x;
        *x ^= *y;
    }
    return *x;
}

void swap(int a, int b)
{
    int temp;
    temp = a;
    a = b;
    b = temp;
}

void swap2(int *a, int *b)
{
    int temp;
    temp = *a;
    *a = *b;
    *b = temp;
}



int main(int argc, const char * argv[]) {
    
    Indicatetest *indicateTest = [[Indicatetest alloc]init];
    [indicateTest indicate];
    
    AppDelegate *obj1 = [[AppDelegate alloc] init];
    AppDelegate *obj2 = [[AppDelegate alloc] init];
    NSLog(@"count = %i\n",[AppDelegate initCount]);
    AppDelegate *obj3 = [[AppDelegate alloc] init];
    NSLog(@"count = %i\n",[AppDelegate initCount]);
    
    [obj1 release];
    [obj2 release];
    [obj3 release];
    
    Shape *obj = [[Shape alloc] init];
    [obj setFillColor:@"Green"];
    [obj draw];
    Circle *objCir = [[Circle alloc] init];
    [objCir setFillColor:@"Orange"];
    [objCir draw];
    Rectangle *objRec = [[Rectangle alloc] init];
    [objRec setFillColor:@"Blue"];
    [objRec draw];
    
    [obj release];
    [objCir release];
    [objRec release];
    
    MemoryManage *memoryObj = [[MemoryManage alloc] init];
    [memoryObj retaincount];
    [memoryObj release];
    
    @autoreleasepool
    {
        NSSet *set1 = [NSSet setWithObjects:@"a",@"b",@"c",@"d",nil];
        NSSet *set2 = [NSSet setWithObjects:@"1",@"2",@"3",nil];
        NSArray *arr = [NSArray arrayWithObjects:@"a",@"b",@"c", nil];
        NSSet *set3 = [NSSet setWithArray:arr];
        NSLog(@"Set1 = %@\n",set1);
        NSLog(@"Set2 = %@\n",set2);
        NSLog(@"Set3 = %@\n",set3);
        
        //get the set count
        NSLog(@"The set1 count is %lu\n",(unsigned long)set1.count);
        
        //To get all objects by an array
        NSArray *arr2 = [set2 allObjects];
        NSLog(@"Set2 is %@\n",arr2);
        
        //To get any object
        NSLog(@"Any object of set3 is %@\n",[set3 anyObject]);
        
        //If contains an object
        NSLog(@"intersect obj is %hhd\n",[set3 intersectsSet:set1]);
        NSLog(@"intersect obj is %hhd\n",[set1 intersectsSet:set3]);
        
        //If match between two sets
        NSLog(@"IsEqual:%d\n",[set1 isEqualToSet:set2]);
        
        //Is sub set or not
        NSLog(@"Is Sub set:%d\n",[set3 isSubsetOfSet:set1]);
        
        NSSet *set4 = [NSSet setWithObjects:@"a",@"b", nil];
        NSArray *arr3 = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4", nil];
        NSSet *set5 = [set4  setByAddingObjectsFromArray:arr3];
        NSLog(@"set5 is :%@\n",set5);
        
        NSMutableSet *mutableSet1 = [NSMutableSet setWithObjects:@"a",@"b",@"c", nil];
        NSMutableSet *mutableSet2 = [NSMutableSet setWithObjects:@"1",@"c",@"b", nil];
        NSMutableSet *mutableSet3 = [NSMutableSet setWithObjects:@"a",@"2",@"b", nil];
       
        [mutableSet1 minusSet:mutableSet2];
        NSLog(@"minusSet:%@\n",mutableSet1);
        
        [mutableSet1 intersectSet:mutableSet3];
        NSLog(@"intersect:%@\n",mutableSet1);
        
        [mutableSet2 unionSet:mutableSet3];
        NSLog(@"unionSet:%@\n",mutableSet2);
        
        [mutableSet1 removeObject:@"b"];
        NSLog(@"set1 is:%@\n",mutableSet1);
        
        [mutableSet1 removeAllObjects];
        NSLog(@"set1 is:%@\n",mutableSet1);
    }
    
    int a[2]={1,2,3};
    for(int i=0;i<3;i++)
    {
        NSLog(@"%i",a[i]);
    }
    
    NSLog(@"howmany = %i\n",howmany(5, 2));
    NSLog(@"roundup = %i\n",roundup(7, 2));
    NSLog(@"powerof2 = %i\n",powerof2(0));
    NSLog(@"MIN = %i\n",MIN(3, 4));
    NSLog(@"MAX = %i\n",MAX(3, 4));
    
    int x = 2, y=3;
    SWAP(x, y);
    NSLog(@"x=%i,y=%i\n",x,y);
    
    NSLog(@"The max = %i\n",COMPARE(3,4,9));
    
    x = 3, y=6;
    int *xp = &x;
    int *yp = &y;
    NSLog(@"x=%i,y=%i,max(x,y) = %i,x=%i,y=%i\n",x,y,max(x, y),x,y);
    NSLog(@"x=%i,y=%i,max2(x,y)= %i,x=%i,y=%i\n",x,y,max2(xp,yp),x,y);

    swap(x,y);
    NSLog(@"x=%i,y=%i\n",x,y);
    swap2(&x, &y);
    NSLog(@"x=%i,y=%i\n",x,y);
    
    return 0;
}
