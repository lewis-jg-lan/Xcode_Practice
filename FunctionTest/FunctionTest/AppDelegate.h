//
//  AppDelegate.h
//  FunctionTest
//
//  Created by Linda8_Yang on 16/12/6.
//  Copyright © 2016年 Linda8_Yang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

static int count;

@interface AppDelegate : NSObject <NSApplicationDelegate>

+(int)initCount;
+(void)initialize;

@end


typedef NSString* shapeColor;
typedef struct
{
    int x;
    int y;
    int width;
    int height;
}ShapeRect;

@interface Shape:NSObject
{
    shapeColor fillcolor;
    ShapeRect bounds;
}
@property (nonatomic,assign)shapeColor fillcolor;

-(void)setFillColor:(shapeColor)color;
-(void)setBounds:(ShapeRect)bound;
-(void)draw;
@end


@interface Circle : Shape
@end

@interface Rectangle : Circle

@end


#define kFiled1Key @"Filed1"
#define kFiled2Key @"Filed2"
#define kFiled3Key @"Filed3"
#define kFiled4Key @"Filed4"
//
//@protocol  NSCoding
//
//-(void)encodeWithCoder:(NSCoder *)encoder;
//-(id)initWithCoder:(NSCoder *)decoder;
//@end
//
//@protocol  NSCopying
//-(id)copyWithZone:(NSZone *)zone;
//
//@end

@interface FourLines : NSObject<NSCopying,NSCoding>
{
    NSString *filed1;
    NSString *filed2;
    NSString *filed3;
    NSString *filed4;
}
@property (nonatomic,retain)NSString *filed1;
@property (nonatomic,retain)NSString *filed2;
@property (nonatomic,retain)NSString *filed3;
@property (nonatomic,retain)NSString *filed4;

@end


@interface  MemoryManage: NSObject
{
    NSMutableString *str;
    NSMutableArray *array;
}
-(void)retaincount;
@end

@interface Indicatetest : NSObject
-(void)indicate;
@end



