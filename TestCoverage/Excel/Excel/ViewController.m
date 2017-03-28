//
//  ViewController.m
//  Excel
//
//  Created by Linda8_Yang on 16/12/14.
//  Copyright © 2016年 Linda8_Yang. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(IBAction)loadCSVLog:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseFiles:YES];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"csv",@"CSV", nil]];
    [openPanel setAllowsOtherFileTypes:NO];
    if([openPanel runModal] == NSFileHandlingPanelOKButton)
    {
        NSString *urlPath = [[openPanel URL] path];
        if (urlPath)
        {
            [m_txtLoadCsvPath setStringValue:urlPath];
        }
    }
}

-(IBAction)loadUartLog:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowedFileTypes:[NSArray arrayWithObjects:@"txt", nil]];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setCanChooseFiles:YES];
    [openPanel setAllowsMultipleSelection:YES];
    [openPanel setAllowsOtherFileTypes:NO];
    if([openPanel runModal] == NSFileHandlingPanelOKButton)
    {
        NSString *urlPath = [[openPanel URL] path];
        if (urlPath)
        {
            [m_txtLoadUartPath setStringValue:urlPath];
        }
    }
    
}

-(void)generateTestcoverage:(NSString *)csvFile withUartFile:(NSString *)uartFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contentOfCsvFile = [fileManager contentsOfDirectoryAtPath:csvFile error:nil];
    NSLog(@"content of file is:\n[%@]",contentOfCsvFile);
}

-(IBAction)openTestcoverage:(id)sender
{
    [self generateTestcoverage: [m_txtLoadCsvPath stringValue] withUartFile:[m_txtLoadUartPath stringValue]];
    
}



@end
