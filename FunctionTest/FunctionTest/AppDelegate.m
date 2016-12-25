//
//  AppDelegate.m
//  FunctionTest
//
//  Created by Linda8_Yang on 16/12/6.
//  Copyright © 2016年 Linda8_Yang. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()
@end

@implementation AppDelegate
-(id)init
{
    self = [super init];
    if (self)
    {
        count++;
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

+(int)initCount
{
    return count;
}

+(void)initialize
{
    count = 0;
}
@end



@implementation Shape
@synthesize fillcolor;

-(id)init
{
    if (self = [super init])
    {
        bounds.x = 10;
        bounds.y = 11;
        bounds.width = 13;
        bounds.height = 14;
    }
    return self;
}

-(void)setFillColor:(shapeColor)color
{
    fillcolor = color;
}

-(void)setBounds:(ShapeRect)bound
{
    bounds = bound;
}

-(void)draw
{
    NSLog(@"draw at %d,%d,%d,%d for %@",bounds.x,bounds.y,bounds.height,bounds.width,fillcolor);
}

@end

@implementation Circle
-(id)init
{
    if (self = [super init])
    {
        bounds.height = 22;
        bounds.width = 32;
        bounds.x = 2;
        bounds.y = 8;
    }
    return self;
}

-(void)draw
{
    NSLog(@"draw at %d,%d,%d,%d for %@",bounds.x,bounds.y,bounds.height,bounds.width,fillcolor);
}

@end


@implementation Rectangle
-(void)draw
{
    NSLog(@"draw at %d,%d,%d,%d for %@",bounds.x,bounds.y,bounds.height,bounds.width,fillcolor);
}
@end


@implementation FourLines
@synthesize filed1;
@synthesize filed2;
@synthesize filed3;
@synthesize filed4;

#pragma mark NSCoding
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:filed1 forKey:kFiled1Key];
    [encoder encodeObject:filed2 forKey:kFiled2Key];
    [encoder encodeObject:filed3 forKey:kFiled3Key];
    [encoder encodeObject:filed4 forKey:kFiled4Key];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init])
    {
        self.filed1 = [decoder decodeObjectForKey:kFiled1Key];
        self.filed2 = [decoder decodeObjectForKey:kFiled2Key];
        self.filed3 = [decoder decodeObjectForKey:kFiled3Key];
        self.filed4 = [decoder decodeObjectForKey:kFiled4Key];
    }
    return self;
}


#pragma mark NSCopying
-(id)copyWithZone:(NSZone *)zone
{
    FourLines *copy = [[[self class] allocWithZone:zone] init];
    copy.filed1 = [self.filed1 copy];
    copy.filed2 = [self.filed2 copy];
    copy.filed3 = [self.filed3 copy];
    copy.filed4 = [self.filed4 copy];
    
    id<NSCopying,NSCoding>filed1;
    NSLog(@"filed1 = %@",filed1);
    return copy;
}
@end

@implementation MemoryManage
-(id)init
{
    if (self = [super init])
    {
        str = [[NSMutableString alloc]initWithString:@"Abc"];
        array = [[NSMutableArray alloc]init];

    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
    [array release];
}

-(void)retaincount
{
    //str = [self returnString];
    NSUInteger a1 = [str retainCount];
    NSUInteger a2 = [array retainCount];
    
    [array addObject:str];
    NSUInteger a3 = [array retainCount];
    NSUInteger a4 = [str retainCount];
    
    [str release];
    NSUInteger a5 = [str retainCount];
    NSUInteger a6 = [array retainCount];
    [array removeObject:str];
    NSUInteger a7 = [array retainCount];
    
    NSLog(@"a1=%lu,a2=%lu,a3=%lu,a4=%lu,a5=%lu,a6=%lu,a7=%lu",(unsigned long)a1,(unsigned long)a2,(unsigned long)a3,(unsigned long)a4,(unsigned long)a5,(unsigned long)a6,(unsigned long)a7);
}

@end

@implementation Indicatetest

-(void)indicate
{
    //1.contain and has a loop
    NSArray *arrayFilter = [NSArray arrayWithObjects:@"pict",@"blackrain",@"ip",nil];
    NSArray *arrayContents = [NSArray arrayWithObjects:@"I am a picture",@"I am a guy",@"I am gagaaa",@"ipad",@"iphone",nil];
    
    NSInteger count = [arrayFilter count];
    for (int i = 0; i < count; ++i)
    {
        NSString *arrayItem = (NSString*)[arrayFilter objectAtIndex:i];
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS%@",arrayItem];
        NSLog(@"Filtered array with filter %@, %@",arrayItem,[arrayContents filteredArrayUsingPredicate:filterPredicate]);
    }
    
    //2.in and no loop
    NSArray *arrFilter = [NSArray arrayWithObjects:@"abc1",@"abc2",nil];
    NSMutableArray *arrContent = [NSMutableArray arrayWithObjects:@"a1",@"abc1",@"abc4",@"abc2",nil];
    NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"NOT(SELF in %@)",arrFilter];
    [arrContent filterUsingPredicate:thePredicate];
    NSLog(@"arrFilter=%@,arrContent=%@",arrFilter,arrContent);
    
    //3.生成文件路径下文件集合列表
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *mainBundle = [[NSBundle mainBundle] resourcePath];
    NSError *error = nil;
    NSArray *directoryOfPath = [fileManager contentsOfDirectoryAtPath:mainBundle error:&error];
    NSLog(@"%@",directoryOfPath);
    
    //4.简单比较
    NSString *match = @"imagexyz-999.png";
    thePredicate = [NSPredicate predicateWithFormat:@"SELF == %@",match];
    NSArray *result = [directoryOfPath filteredArrayUsingPredicate:thePredicate];
    NSLog(@"arrContent = %@",result);
    
    //like,［c］表示忽略大小写，［d］表示忽略重音，可以在一起使用
    thePredicate = [NSPredicate predicateWithFormat:@"SELF like[cd] %@",match];
    NSLog(@"result=%@",[directoryOfPath filteredArrayUsingPredicate:thePredicate]);
    
    
    
    
    
    
    
    
}

@end


