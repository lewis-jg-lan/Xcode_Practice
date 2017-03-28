//
//  ViewController.h
//  Excel
//
//  Created by Linda8_Yang on 16/12/14.
//  Copyright © 2016年 Linda8_Yang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
{
    IBOutlet NSTextField    *m_txtLoadCsvPath;
    IBOutlet NSButton   *m_btnLoadCsv;
    IBOutlet NSTextField    *m_txtLoadUartPath;
    IBOutlet NSButton   *m_btnLoadUart;
    
    NSString *testCoveragePath;
}
-(IBAction)loadCSVLog:(id)sender;
-(IBAction)loadUartLog:(id)sender;
-(void)generateTestcoverage:(NSString *)csvFile withUartFile:(NSString *)uartFile;
-(IBAction)openTestcoverage:(id)sender;


@end

