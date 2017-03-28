//
//  AppDelegate.m
//  USBDevice
//
//  Created by Scott on 16/11/28.
//  Copyright © 2016年 PEGATRON. All rights reserved.
//

#import "AppDelegate.h"
//#import <CoreFoundation/CoreFoundation.h>
#include <IOKit/IOKitLib.h>
#include <IOKit/usb/IOUSBLib.h>
#include <IOKit/IOCFPlugIn.h>

#include <IOKit/serial/IOSerialKeys.h>

@interface AppDelegate ()

@property (assign) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

@synthesize deviceTable;
@synthesize gDeviceArray;

- (id)init
{
    self = [super init];
    
    if (self)
    {
         gDeviceArray = [[NSMutableArray alloc] initWithCapacity: 0];
        
    }
    return self;
}
- (void)dealloc
{
    [gDeviceArray release];gDeviceArray = nil;
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self DetectUSBDevice];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

void SignalHandler(int sigraised)
{
    fprintf(stderr, "\nInterrupted.\n");

    exit(0);
}

-(int) DetectUSBDevice
{
    CFMutableDictionaryRef 	matchingDict;
    CFRunLoopSourceRef		runLoopSource;
    kern_return_t			kr;
    sig_t					oldHandler;
    mach_port_t masterPort;
    
    // Set up a signal handler so we can clean up when we're interrupted from the command line
    // Otherwise we stay in our run loop forever.
    oldHandler = signal(SIGINT, SignalHandler);
    if (oldHandler == SIG_ERR) {
        fprintf(stderr, "Could not establish new signal handler.");
    }
    
    // Returns the mach port used to initiate communication with IOKit.
    kr = IOMasterPort(MACH_PORT_NULL, &masterPort);
    if (kr != kIOReturnSuccess) {
        printf("%s(): IOMasterPort() returned %08x\n", __func__, kr);
        return -1;
    }
    
    matchingDict = IOServiceMatching(kIOUSBDeviceClassName);
    if (matchingDict == NULL) {
        printf("%s(): IOServiceMatching returned a NULL dictionary.\n", __func__);
        return -1;
    }

    // increase the reference count by 1 since die dict is used twice.
    CFRetain(matchingDict);
    
    // Create a notification port and add its run loop event source to our run loop
    // This is how async notifications get set up.
    
   	gNotifyPort = IONotificationPortCreate(masterPort);
    runLoopSource = IONotificationPortGetRunLoopSource(gNotifyPort);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopDefaultMode);
    
    kr = IOServiceAddMatchingNotification(gNotifyPort,
                                           kIOFirstMatchNotification,
                                           matchingDict,
                                           staticDeviceAdded,
                                           self,
                                           &gNewDeviceAddedIter);
    
    // Iterate once to get already-present devices and arm the notification
    [self deviceAdded: gNewDeviceAddedIter];
    
    kr = IOServiceAddMatchingNotification(gNotifyPort,
                                           kIOTerminatedNotification,
                                           matchingDict,
                                           staticDeviceRemoved,
                                           self,
                                           &gNewDeviceRemovedIter);
    
    // Iterate once to get already-present devices and arm the notification
    [self deviceRemoved : gNewDeviceRemovedIter];
    
    // done with the masterport
   // CFRunLoopRun();
    mach_port_deallocate(mach_task_self(), masterPort);
    return 0;
}

static void staticDeviceAdded (void *refCon, io_iterator_t iterator)
{
    AppDelegate *del = refCon;
    if (del)
        [del deviceAdded : iterator];
}

static void staticDeviceRemoved (void *refCon, io_iterator_t iterator)
{
    AppDelegate *del = refCon;
    if (del)
        [del deviceRemoved : iterator];
}

-(void) deviceAdded: (io_iterator_t) iterator
{
    kern_return_t		kr;
    io_service_t		usbDevice;
    IOCFPlugInInterface	**plugInInterface = NULL;
    IOUSBDeviceInterface	**dev = NULL;
    CFMutableDictionaryRef	entryProperties = NULL;
    SInt32				score;
    HRESULT 			res;
    UInt16 vendorID, productID;
    UInt32 locationID;
    
    while ((usbDevice = IOIteratorNext(iterator)))
    {
        printf("%s(): device added %d.\n", __func__, (int) usbDevice);
        
        IORegistryEntryCreateCFProperties(usbDevice, &entryProperties, NULL, 0);
        
        
  
        kr = IOCreatePlugInInterfaceForService(usbDevice,
                                               kIOUSBDeviceUserClientTypeID,
                                               kIOCFPlugInInterfaceID,
                                               &plugInInterface,
                                               &score);
        
        if ((kr != kIOReturnSuccess) || !plugInInterface)
        {
            printf("%s(): Unable to create a plug-in (%08x)\n", __func__, kr);
            continue;
        }
        
        // create the device interface
        res = (*plugInInterface)->QueryInterface(plugInInterface,
                                                CFUUIDGetUUIDBytes(kIOUSBDeviceInterfaceID),
                                                (LPVOID *)&dev);
        // Now done with the plugin interface.
        (*plugInInterface)->Release(plugInInterface);
        if (res || !dev) {
            printf("%s(): Couldn’t create a device interface (%08x)\n", __func__, (int) res);
            continue;
        }
        
        NSMutableDictionary *dicTemp = [NSMutableDictionary dictionary];
        kr=(*dev)->GetDeviceVendor(dev, &vendorID);
        if (KERN_SUCCESS != kr) {
            fprintf(stderr, "vendorID returned 0x%04x.\n", vendorID);
            continue;
        }
        kr=(*dev)->GetDeviceProduct(dev, &productID);
        if (KERN_SUCCESS != kr) {
            fprintf(stderr, "productID returned 0x%04x.\n", productID);
            continue;
        }
        kr=(*dev)->GetLocationID(dev,&locationID);
        if (KERN_SUCCESS != kr) {
            fprintf(stderr, "GetLocationID returned 0x%08x.\n", locationID);
            continue;
        }
        NSString *name = (NSString *) CFDictionaryGetValue(entryProperties, CFSTR(kUSBProductString));
        if (!name)
            continue;
        
        NSString *bcdUSB = (NSString *) CFDictionaryGetValue(entryProperties, CFSTR(kUSBSerialNumberString));
        if(!bcdUSB)
            bcdUSB = @"-";
        
        usleep(500000);
        NSString *szBSDPath = @"-";
        CFStringRef	bsdPath = (CFStringRef)IORegistryEntrySearchCFProperty(usbDevice,
                                                                           kIOServicePlane,
                                                                           CFSTR(kIOCalloutDeviceKey),
                                                                           kCFAllocatorDefault,
                                                                           kIORegistryIterateRecursively);
        
        if(bsdPath)
        {
            szBSDPath = (__bridge NSString *)bsdPath;
        }
        
        printf(" *dev = %p\n", *dev);
        
        [dicTemp setObject: [NSString stringWithFormat: @"0x%04x", vendorID]
                 forKey: @"VID"];
        [dicTemp setObject: [NSString stringWithFormat: @"0x%04x", productID]
                 forKey: @"PID"];
        [dicTemp setObject: [NSString stringWithString: name]
                 forKey: @"Name"];
        [dicTemp setObject: [NSValue valueWithPointer: dev]
                 forKey: @"Dev"];
        [dicTemp setObject: [NSNumber numberWithInt: usbDevice]
                 forKey: @"Service"];
        [dicTemp setObject: [NSString stringWithFormat: @"0x%x", (unsigned int)locationID]
                 forKey: @"LocationID"];
        [dicTemp setObject: [NSString stringWithString:szBSDPath]
                    forKey: @"BSDName"];
        [gDeviceArray addObject:dicTemp];
        
        // Done with this USB device; release the reference added by IOIteratorNext
        //kr = IOObjectRelease(usbDevice);
    }
    [deviceTable reloadData];
}

- (void) deviceRemoved: (io_iterator_t) iterator
{
    io_service_t usbDevice;
    
    while ((usbDevice = IOIteratorNext(iterator)))
    {
        NSEnumerator *enumerator = [gDeviceArray objectEnumerator];
        printf("%s(): device removed %d.\n", __func__, (int) usbDevice);
        NSDictionary *dict;
        
        while (dict = [enumerator nextObject])
        {
            if ((io_service_t) [[dict valueForKey: @"Service"] intValue] == usbDevice) {
                [gDeviceArray removeObject: dict];
                break;
            }
        }
        
        IOObjectRelease(usbDevice);
    }
    [deviceTable reloadData];
}
#pragma mark ######### table view data source protocol ############

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)col
            row:(NSInteger)rowIndex
{
    NSDictionary *dict = [gDeviceArray objectAtIndex: rowIndex];
    return [dict valueForKey: [col identifier]];
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [gDeviceArray count];
}

-(void)upateTableView:(NSString *)str
{
    [deviceTable reloadData];
}


@end
