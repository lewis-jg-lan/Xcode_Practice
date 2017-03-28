//
//  AppDelegate.m
//  ARC_MRC_TEST
//
//  Created by Linda8_Yang on 17/3/1.
//  Copyright © 2017年 Linda8_Yang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)testStringAddress
{
    NSString *str = @"Hello World";
    
#if __has_feature(objc_arc)
    __weak   NSString *weakStr = str;
    __strong NSString *strongStr = str;
#else
    NSString *retainStr = [str retain];
#endif
    
    NSString *copyStr = [str copy];
    NSMutableString *mutableCopyStr = [str mutableCopy];
    
    // 验证mutableCopy出来的是否是mutableString，如果不是执行此行会Crash
    [mutableCopyStr appendFormat:@".."];
    str = @"i'm changed";
    
    NSString *str2 = [NSString stringWithFormat:@"Hello world"];
    
#if __has_feature(objc_arc)
    __weak   NSString *weakStr2 = str2;
    __strong NSString *strongStr2 = str2;
#else
    NSString *retainStr2 = [str2 retain];
#endif
    
    NSString *copyStr2 = [str2 copy];
    NSString *mutableCopyStr2 = [str2 mutableCopy];
    str2 = [[NSString alloc] initWithFormat:@"changed"];
    
    NSMutableString *mutableStr = [NSMutableString stringWithString:@"hello world"];
    
#if __has_feature(objc_arc)
    __weak   NSMutableString *weakMutableStr = mutableStr;
    __strong NSMutableString *strongMutableStr = mutableStr;
#else
    NSMutableString *retainMutableStr = [mutableStr retain];
#endif
    
    NSMutableString *copyMutableStr = [mutableStr copy];
    NSMutableString *copy2MutableStr = [mutableStr copy];
    NSString *mutableCopyMutableStr = [mutableStr mutableCopy];
    NSString *mutableCopy2MutableStr = [mutableStr mutableCopy];
    [mutableStr appendFormat:@" apped something"];
    
#if __has_feature(objc_arc)
    NSLog(@"\r str: %@,\r weakStr: %@,\r strongStr: %@,\r copyStr: %@,\r mutableCopyStr: %@", str, weakStr, strongStr, copyStr, mutableCopyStr);
    NSLog(@"\r str2: %@,\r weakStr2: %@,\r strongStr: %@,\r copyStr2: %@,\r mutableCopyStr2: %@", str2, weakStr2, strongStr2, copyStr2, mutableCopyStr2);
    NSLog(@"\r mutableStr: %@,\r weakMutableStr: %@\r strongMutableStr: %@,\r copyMutableStr: %@,\r copy2MutableStr:%@\rmutableCopyMutableStr: %@\r mutableCopy2MutableStr:%@", mutableStr, weakMutableStr, strongMutableStr, copyMutableStr, copy2MutableStr, mutableCopyMutableStr, mutableCopy2MutableStr);
#else
    NSLog(@"\r str: %@,\r retain Str: %@,\r copyStr: %@,\r mutableCopyStr: %@", str, retainStr, copyStr, mutableCopyStr);
    NSLog(@"\r str2: %@,\r retainStr2: %@,\r copyStr2: %@,\r mutableCopyStr2: %@", str2, retainStr2, copyStr2, mutableCopyStr2);
    NSLog(@"\r mutableStr: %@,\r retainMutableStr: %@\r copyMutableStr: %@,\r copy2MutableStr:%@\rmutableCopyMutableStr: %@\r mutableCopy2MutableStr:%@", mutableStr,retainMutableStr, copyMutableStr, copy2MutableStr, mutableCopyMutableStr, mutableCopy2MutableStr);
    
#endif
}

@end
