//
//  AppDelegate.h
//  onlyTC
//
//  Created by Felix_zheng on 15/10/5.
//  Copyright (c) 2015年 Felix. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "LibXL/libxl.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>{
    
    IBOutlet NSTextField *txtFilePath;
    NSString *m_strXlName;
    NSString *m_strSheetName;
    //NSMatrix *excelFormat;
    IBOutlet NSButton *isWriteToHaveAddr;
//    IBOutlet NSTextField *txtWriteToPath;
    NSString *m_textPlistPath;
    IBOutlet NSTextField *textTalk;
}

- (IBAction)btnDo:(id)sender;
@property (assign) IBOutlet NSMatrix *excelFormat;
- (IBAction)btnChoose:(id)sender;
//-(void)writeToSheet:(SheetHandle*)sheet;
@end

