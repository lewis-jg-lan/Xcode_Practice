//
//  AppDelegate.h
//  USBDevice
//
//  Created by Scott on 16/11/28.
//  Copyright © 2016年 PEGATRON. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    NSTableView *deviceTable;
    
    NSMutableArray			*gDeviceArray;
    IONotificationPortRef	gNotifyPort;
    io_iterator_t			gNewDeviceAddedIter;
    io_iterator_t			gNewDeviceRemovedIter;
}

@property(assign) IBOutlet NSTableView *deviceTable;
@property(assign) NSMutableArray *gDeviceArray;
void DeviceAdded(void *refCon, io_iterator_t iterator);

@end

