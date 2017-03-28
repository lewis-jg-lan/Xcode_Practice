//
//  AppDelegate.m
//  onlyTC
//
//  Created by Felix_zheng on 15/10/5.
//  Copyright (c) 2015年 Felix. All rights reserved.
//
//Users/Felix_MAC/Desktop/overlay/onlyTC/onlyTC/Base.lproj/MainMenu.xib
#import "AppDelegate.h"
#import "NSStringCategory.h"
#import "LibXL/libxl.h"
@interface AppDelegate ()

@property IBOutlet NSWindow *window;
@end

@implementation AppDelegate
@synthesize excelFormat;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
-(NSArray*)getParameter: (NSString*)strFilePath {
   // strFilePath = [txtFilePath stringValue];
    NSString *strData= [[NSString alloc]initWithContentsOfFile:strFilePath encoding:NSUTF8StringEncoding error:nil];
    if ([strFilePath contains:@"_Uart"]){
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"MM-dd"];
  //  NSString *date=[nsdf2 stringFromDate:[NSDate date]];

    if (![strData contains:@"PROJECT:"]||![strData contains:@"STATION:"]) {
        NSAlert *alert = [[NSAlert alloc]init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"警告(Warning)!"];
        NSString *strInfoText = [NSString stringWithFormat:@"URAT Log 格式不正确 ，请确认！"];
        [alert setInformativeText:strInfoText];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert beginSheetModalForWindow:_window completionHandler:nil];
        return nil;
    }

    m_strSheetName = [[strData SubFrom:@"START_TEST_" include:NO]SubTo:@"(Item0)" include:NO];
 //   NSString *strProject =[[strData SubFrom:@"PROJECT:" include:NO]SubTo:@"STATION:" include:NO];
//    m_strXlName = [NSString stringWithFormat:@"%@QTX_%@",strProject,date];
//    m_strXlName = [m_strXlName stringByReplacingOccurrencesOfString:@"\n" withString:@"_"];
    NSString *strProject =[[[[txtFilePath stringValue]lastPathComponent] SubFrom:@"_" include:NO]SubTo:@"_Uart" include:NO];
        m_strXlName = [NSString stringWithFormat:@"%@_%@",m_strSheetName,strProject];
    return [self getParameterFromData:strData];
    }else if([strFilePath contains:@"_DEBUG"]){
        return [self handleDebugLogData:strData];
    }else {
        return nil;
    }
    
}
- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss.SSS"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    //[dateFormatter release];b
    return destDate;
    
}
-(NSArray*)handleDebugLogData:(NSString*)data  {
    data = [data SubFrom:@"===== START TEST" include:YES];
    NSArray *aryData = [data componentsSeparatedByString:@"===== START TEST "];
    
    NSMutableArray *aryAll =[NSMutableArray array];
    
    for( NSString* strTemp in aryData){
        NSMutableArray *aryParameter =[NSMutableArray array];
        NSMutableDictionary* dicSingleItem =[NSMutableDictionary dictionary];
        NSString* strItemName = [[strTemp SubFrom:@"Item Name:" include:NO]SubTo:@"," include:NO];
        [dicSingleItem setValue:strItemName forKey:@"ItemName"];
         NSArray *aryDataForSingleItem = [strTemp componentsSeparatedByString:@"+ ["];
        NSMutableArray *arrRootCycle = [NSMutableArray arrayWithArray:aryDataForSingleItem];
        for (int iCount = 0; iCount <[arrRootCycle count]; iCount++) {
            NSString *strTempForSingleItem = [arrRootCycle objectAtIndex:iCount];
            if (![strTempForSingleItem containsString:@") +"]) {
                [arrRootCycle removeObjectAtIndex:iCount];
                iCount--;
            }
        }
        for (int iCount = 0; iCount <[arrRootCycle count]; iCount++) {
             NSString *strTempForSingleItem = [arrRootCycle objectAtIndex:iCount];
             strTempForSingleItem = [strTempForSingleItem SubTo:@") +" include:NO];
             NSString *strSubItem = [strTempForSingleItem SubTo:@": (" include:NO];
             [dicSingleItem setValue:strSubItem forKey:@"SubItemName"];
             NSString *strSubItemResult = [[strTempForSingleItem SubFrom:@"TestResult : " include:NO]SubTo:@" ;" include:NO];
             [dicSingleItem setValue:strSubItemResult forKey:@"SubItemResult"];
              NSString *strSubItemDuration = [strTempForSingleItem SubFrom:@"Duration : " include:NO];
             [dicSingleItem setValue:strSubItemDuration forKey:@"SubItemDuration"];
             [aryParameter  addObject:[dicSingleItem copy]];

        }
        [aryAll addObject:aryParameter];
    }
    //for 合并单元格 bug
    NSMutableArray *aryEnd = [NSMutableArray array];
    NSMutableDictionary *dicEnd = [NSMutableDictionary dictionary];
    [dicEnd setObject:@"" forKey:@"ItemName"];
   // [aryEnd removeAllObjects];
    [aryEnd addObject:dicEnd];
    [aryAll addObject:aryEnd];
    
    return aryAll;
}
-(NSArray*)getParameterFromData: (NSString*)data{
    data = [data SubFrom:@"===== START TEST" include:YES];
    NSArray *aryData = [data componentsSeparatedByString:@"===== START TEST "];
   
    NSMutableArray *aryAll =[NSMutableArray array];
   
    for( NSString* strTemp in aryData){
        NSString* strDurationTime = [NSString string];
        NSMutableArray *aryParameter =[NSMutableArray array];
        NSMutableDictionary* dicSingleItem =[NSMutableDictionary dictionary];
        NSString* strItemName = [[strTemp SubFrom:@"Item Name:" include:NO]SubTo:@"," include:NO];
        NSString* strSpecSubFrom = [NSString stringWithFormat:@"%@,",strItemName];
        NSString* strSPec =[[strTemp SubFrom:strSpecSubFrom include:NO]SubTo:@"====" include:NO];
        [dicSingleItem setValue:strItemName forKey:@"ItemName"];
        [dicSingleItem setValue:strSPec forKey:@"Spec"];
        
        NSArray *aryDataForSingleItem = [strTemp componentsSeparatedByString:@"[20"];
        if ([aryDataForSingleItem count] == 1) {
            [aryParameter  addObject:[dicSingleItem copy]];
        }else {
        NSMutableArray *arrRootCycle = [NSMutableArray arrayWithArray:aryDataForSingleItem];
        for (int iCount = 0; iCount <[arrRootCycle count]; iCount++) {
            NSString *strTempForSingleItem = [arrRootCycle objectAtIndex:iCount];
            if ((![strTempForSingleItem containsString:@"TX ==>"])&&(![strTempForSingleItem containsString:@"RX ==> "])) {
                [arrRootCycle removeObjectAtIndex:iCount];
                iCount--;
            }
//            }else if ([strTempForSingleItem containsString:@"RX ==>"]&&[strItemName isEqualToString:@"Check DUT Mode"]&&![strTempForSingleItem containsString:@"(RX ==> [MOBILE]):\n"]){
//                NSString *strReponse = [[strTemp SubFrom:@") ==================================" include:NO]SubTo:@"(RX ==> [MOBILE]):\n" include:NO];
//               strReponse = [[strReponse SubFrom:@"(TX ==> [MOBILE]):\n[20" include:NO]SubTo:@"(TX ==> [MOBILE]):\n[20" include:NO];
//                strReponse = [strReponse stringByReplacingOccurrencesOfString:@"(TX ==> [MOBILE]):" withString:@""];
//
//                [arrRootCycle replaceObjectAtIndex:iCount withObject:strReponse];
//            }else if ([strTempForSingleItem containsString:@"RX ==> [MOBILE]"]&&[strItemName isEqualToString:@"START_TEST_SA-SENSORFLEX"]&&![strTempForSingleItem containsString:@"(RX ==> [MOBILE]):\n"]){
//                NSString *strReponse = [[strTemp SubFrom:@") ==================================" include:NO]SubTo:@"(RX ==> [MOBILE]):\n" include:NO];
//                strReponse = [[strReponse SubFrom:@"(TX ==> [MOBILE]):\n[20" include:NO]SubTo:@"(TX ==> [MOBILE]):\n[20" include:NO];
//                strReponse = [strReponse stringByReplacingOccurrencesOfString:@"(TX ==> [MOBILE]):" withString:@""];
//                
//                [arrRootCycle replaceObjectAtIndex:iCount withObject:strReponse];
//            }

        }
        
        for (int i =0 ;i<[arrRootCycle count];i++) {
            NSString *strTempForSingleItem = [arrRootCycle objectAtIndex:i];
            if ([strTempForSingleItem containsString:@"TX ==> "]) {
                NSString*  strCommand = [strTempForSingleItem SubFrom:@"TX ==> [" include:YES];
                [dicSingleItem setObject:[strCommand copy] forKey:@"Command"];
            }else if ([strTempForSingleItem containsString:@"RX ==> "]){
                NSString* strTarget = [[strTempForSingleItem SubFrom:@"==> [" include:NO]SubTo:@"]" include:NO];
                NSString* strResponseSubTo = [NSString string];
                BOOL bInclude = YES;
                if ([strTarget isEqualToString:@"MOBILE"]) {
                    strResponseSubTo =@":-)";
                    bInclude = YES;
                }
                if ([strTarget isEqualToString:@"FIXTURE"]) {
                    strResponseSubTo =@"@_@";
                    bInclude = YES;
                }
                if ([strTarget isEqualToString:@"34401_Instrument"]) {
                    strResponseSubTo =@"Item Name";
                    bInclude = NO;
                }

                
                NSString*  strResponse = [[strTempForSingleItem SubFrom:@"(RX ==>" include:YES]SubTo:strResponseSubTo include:bInclude];
                if([strTempForSingleItem contains:@"bblib -e 'BB_SMTQT()"]||[strTempForSingleItem contains:@":smokey --"]){
                    strResponse = [strTempForSingleItem SubFrom:@"(RX ==>" include:YES];
                }
                if (![strResponse contains:@"(RX ==>"]) {
                    strResponse = @"";
                }
                [dicSingleItem setObject:[strResponse copy] forKey:@"Response"];
                
            }
            if (i%2!=0) {
                NSString *strSendCommand = [arrRootCycle objectAtIndex:i-1];
                NSString *strSendCommandTime = [strSendCommand SubTo:@"](" include:NO];
                NSString *strResponseTime = [strTempForSingleItem SubTo:@"](" include:NO];
                strSendCommandTime = [NSString stringWithFormat:@"20%@",strSendCommandTime];
                strResponseTime = [NSString stringWithFormat:@"20%@",strResponseTime];
                NSDate *dateSendCommand = [self dateFromString:strSendCommandTime];
                NSDate *dateSendResponse = [self dateFromString:strResponseTime ];
                NSTimeInterval time = [dateSendResponse timeIntervalSinceDate:dateSendCommand];
                strDurationTime=  [NSString stringWithFormat:@"%.6fs",time];
                [dicSingleItem setObject:[strDurationTime copy] forKey:@"DurationTime"];

                
            }
            //for check dut mode bug
            if (!strDurationTime || ![strDurationTime contains:@"-"]) {
            [aryParameter  addObject:[dicSingleItem copy]];
            }
//            if ([strItemName isEqualToString:@"Check DUT Mode"]&&[aryParameter count]==6) {
//                [aryParameter removeObjectAtIndex:2];
//                [aryParameter removeObjectAtIndex:3];
//            }
        }
        }
        
        if ([aryParameter count] >1) {
            
            for (int i = 0; i<[aryParameter count];i++ ) {
//                NSDictionary *dicItem = [aryParameter objectAtIndex:i];
//                NSString *strCMD = [dicItem objectForKey:@"Command"];
                if (i%2!=0) {
//                    [aryParameter removeObjectAtIndex:i];
                    [aryAll addObject:[aryParameter objectAtIndex:i]];
                   // i--;
                }
            }
        }else if ([aryParameter count] ==1){
            [aryAll addObject:[aryParameter objectAtIndex:0]];
        }

//        [aryAll addObjectsFromArray:aryParameter];
        if (aryAll ==nil) {
            NSAlert *alert = [[NSAlert alloc]init];
            [alert addButtonWithTitle:@"OK"];
            [alert setMessageText:@"警告(Warning)!"];
            NSString *strInfoText = [NSString stringWithFormat:@"无法获取数据，请确认！"];
            [alert setInformativeText:strInfoText];
            [alert setAlertStyle:NSWarningAlertStyle];
            [alert beginSheetModalForWindow:_window completionHandler:nil];
        }
    }
    if ([aryAll count] >1) {
        NSDictionary *dicA = [aryAll objectAtIndex:0];
        [aryAll removeObjectAtIndex:0];
        [aryAll addObject:dicA];
    }

    return aryAll;
}
-(void)debugLogAction:(BOOL)xlsMode{
   // NSArray *arr = [self getParameter:[txtFilePath stringValue]];
    NSString *strCSVPath = [[txtFilePath stringValue]SubTo:@"_Uart.txt" include:NO];
//strCSVPath = [[txtFilePath stringValue]SubTo:@"_Uart.txt" include:NO];
    NSString *strDebugLog = [NSString stringWithFormat:@"%@_DEBUG.txt",strCSVPath];
    strCSVPath = [NSString stringWithFormat:@"%@_CSV.csv",strCSVPath];
    NSMutableDictionary *dicRoot= [self getCycleTime:strCSVPath];
    
//    NSString *strDebugLog = [NSString stringWithFormat:@"%@_DEBUG.txt",strCSVPath];
    NSArray *arr = [self getParameter:strDebugLog];
    FontHandle blueFont;

    FormatHandle blueFormat;
    FormatHandle titleFormat;
    FormatHandle blueFontFormat;
    SheetHandle sheet = nil;
    BookHandle book;
    NSString *strNameXls =[NSString stringWithFormat:@"%@.xls",m_strXlName];
    NSString *strNameXlsx =[NSString stringWithFormat:@"%@.xlsx",m_strXlName];
    NSString *name = xlsMode ? strNameXls:strNameXlsx;
    
    NSString *documentPath =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [documentPath stringByAppendingPathComponent:name];
    filename =  [isWriteToHaveAddr state] ? m_textPlistPath : filename;
    
    book = xlsMode ? xlCreateBook() : xlCreateXMLBook();
    xlBookLoad(book, [filename UTF8String]);
//
    titleFormat = xlBookAddFormat(book, 0);
    xlFormatSetFillPattern(titleFormat, FILLPATTERN_SOLID);
    xlFormatSetPatternForegroundColor(titleFormat, COLOR_BRIGHTGREEN);
    blueFontFormat = xlBookAddFormat(book,0);
    xlFormatSetFont(blueFontFormat,blueFont);
    //sheet = xlBookAddSheet(book,[m_strSheetName UTF8String],nil);
    //sheet = xlBookInsertSheet (book,xlBookSheetCount(book), [m_strSheetName UTF8String], nil);
    //[self returnSheet:book];
    if ([isWriteToHaveAddr state]==1) {
        int iCount = xlBookSheetCount(book); //sheet count
        //get the sheet  by catched the Station name from UartLog
        for(int i = 0; i < iCount; i++)
        {
            sheet  = xlBookGetSheet(book,i);
            const char  * cSheetName   = xlSheetName(sheet);
            NSString    * strSheetName = [NSString stringWithUTF8String:cSheetName];
            strSheetName = [strSheetName stringByReplacingOccurrencesOfString:@" " withString:@""];
            m_strSheetName = [m_strSheetName stringByReplacingOccurrencesOfString:@" " withString:@""];
            if([[strSheetName uppercaseString] isEqualToString:[m_strSheetName uppercaseString]])
            {
                xlBookDelSheet(book,i);
                NSString *strSheetNameSub =[NSString stringWithFormat:@"%@_SubItem",m_strSheetName];

                xlBookInsertSheet(book,i,[strSheetNameSub UTF8String],nil);
                sheet  = xlBookGetSheet(book,i);
                break;
            }
            else if(i != iCount-1)
                continue;
            else
            {
                NSString *strSheetNameSub =[NSString stringWithFormat:@"%@_SubItem",m_strSheetName];
                const char  * cSheetName = [strSheetNameSub cStringUsingEncoding:NSUTF8StringEncoding];
                xlBookAddSheet(book, cSheetName, nil);
                sheet  = xlBookGetSheet(book,i+1);
                break;
            }
        }
    }
    else{
        NSString *strSheetNameSub =[NSString stringWithFormat:@"%@_SubItem",m_strSheetName];
        sheet = xlBookAddSheet(book,[strSheetNameSub UTF8String],nil);
    }
    if(sheet)
    {
        xlSheetWriteStr(sheet, 1, 0, "Color define", 0);

        xlSheetWriteStr(sheet, 6, 0, "", blueFormat);
        xlSheetWriteStr(sheet, 8, 0, "CSV ct (s)",titleFormat);

        xlSheetWriteStr(sheet, 8, 1, "Test Item", titleFormat);
        xlSheetWriteStr(sheet, 8, 2, "Sub Item", titleFormat);
        xlSheetWriteStr(sheet, 8, 3, "Sub Item Result ", titleFormat);
        xlSheetWriteStr(sheet, 8, 4, "Sub Item Duration(s)", titleFormat);
        xlSheetWriteStr(sheet, 8, 5, "Sub Item Duration Total (s)", titleFormat);
        
        
        int i = 0;
        int j = 0;
        int J = 0;
        NSString* str =[NSString string];
        NSString *strItemName = [NSString string];
        
        for (NSArray *arr1 in arr) {
            float fSingle = 0.0 ;
            float x=0.0;
            if (arr1==nil) {
                continue;
            }else if ([arr1 count]>1){
            x = [[[[arr1 objectAtIndex:0] objectForKey:@"SubItemDuration"] SubTo:@"s" include:NO]floatValue ];
            }
            for (NSDictionary *dic in arr1) {
                
               // dic = [arr objectAtIndex:i];
                xlSheetWriteStr(sheet, 9+i, 1, "", 0);
                strItemName = [dic objectForKey:@"ItemName"];
                xlSheetWriteStr(sheet, 9+i, 1, [strItemName UTF8String], 0);
                if(![strItemName isEqualToString: @""]){
                   
                    if ([dic objectForKey:@"SubItemName"]&&[dic objectForKey:@"SubItemResult"]&&[dic objectForKey:@"SubItemDuration"]) {
                        NSString *strCycleTimeSub = [dicRoot objectForKey:strItemName];
                        strCycleTimeSub = [NSString stringWithFormat:@"%@s",strCycleTimeSub];
                        xlSheetWriteStr(sheet,9+i,0,[strCycleTimeSub UTF8String],0);
                        xlSheetWriteStr(sheet,9+i,2,[[dic objectForKey:@"SubItemName"]UTF8String],0);
                        xlSheetWriteStr(sheet,9+i,3,[[dic objectForKey:@"SubItemResult"]UTF8String],0);
                        fSingle = [[[dic objectForKey:@"SubItemDuration"] SubTo:@"s" include:NO]floatValue ];
                        xlSheetWriteStr(sheet,9+i,4,[[dic objectForKey:@"SubItemDuration"]UTF8String],0);
                        xlSheetWriteNum(sheet ,9+i, 5,fSingle,0);
                    }

                }//合并单元格
                //x += fSingle;
            if (i>0 &&[str isEqualToString:strItemName]){
                j++;
                x += fSingle;
                xlSheetWriteNum(sheet, 9+J, 5,x, 0);
             //   NSLog(@"Item: %@ x: %f row: %d ",strItemName,x,J);

            }
            else{
                xlSheetSetMerge(sheet, 9+J, 8+j, 1, 1);
                xlSheetSetMerge(sheet, 9+J, 8+j, 0, 0);

                xlSheetSetMerge(sheet, 9+J, 8+j, 5, 5);
               
               // xlSheetSetMerge(sheet, 9+J, 8+j, 5, 5);
                J = j;
                j++;
            }
            str =[NSString stringWithString:strItemName];
            i++;
        }
        //
        
        // int iCow = xlsheetcol
        xlSheetSetCol(sheet, 1, 1, 40, 0, 0);
        xlSheetSetCol(sheet, 2, 2, 40, 0, 0);
        xlSheetSetCol(sheet, 4, 4, 40, 0, 0);
        }
    }
    //    NSString *name = xlsMode ? @"OTC.xls":@"OTC.xlxs";
    xlBookSave(book, [filename UTF8String]);
    
    xlBookRelease(book);
   // [[NSWorkspace sharedWorkspace] openFile:filename];
}



-(BOOL)imformationFormat:(BOOL)xlsMode{
    [textTalk setStringValue:@""];
    NSArray *arr = [self getParameter:[txtFilePath stringValue]];
    NSString *strCSVPath = [[txtFilePath stringValue]SubTo:@"_Uart.txt" include:NO];
    NSString *strDebugLog = [NSString stringWithFormat:@"%@_DEBUG.txt",strCSVPath];

    strCSVPath = [NSString stringWithFormat:@"%@_CSV.csv",strCSVPath];
        NSFileManager	*fileManager	= [NSFileManager defaultManager];
    if ((![fileManager fileExistsAtPath :strCSVPath]) ||(![fileManager fileExistsAtPath:strDebugLog]) ){
        NSAlert *alert = [[NSAlert alloc]init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"警告(Warning)!"];
        NSString *strInfoText = [NSString stringWithFormat:@"请确认目录下有CSV 、UART 和 Debug log"];
        [alert setInformativeText:strInfoText];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert beginSheetModalForWindow:_window completionHandler:nil];
        return NO;
    }
    NSMutableDictionary *dicRoot= [self getCycleTime:strCSVPath];
    NSString *tempString =[NSString stringWithFormat: @"正在为您写入SubItem表格"];
    //[textTalk setStringValue:tempString];
    [self performSelectorOnMainThread:@selector(UpdateUI:) withObject:tempString waitUntilDone:YES];
    [self debugLogAction:xlsMode];
    tempString = [NSString stringWithFormat: @"正在为您写入Item&Command表格" ];
    [self performSelectorOnMainThread:@selector(UpdateUI:) withObject:tempString waitUntilDone:YES];
    FontHandle boldFont;
    FontHandle redFont;
    FontHandle blueFont;
    FormatHandle greenFormat;
    FormatHandle yellowFormat;
    FormatHandle redFormat;
    FormatHandle blueFormat;
    FormatHandle greyFormat;
    FormatHandle titleFormat;
    FormatHandle grayWhiteFormat;
    FormatHandle pinkFormat;
    FormatHandle blueFontFormat;
    SheetHandle sheet = nil;
    BookHandle book;
    NSString *strNameXls =[NSString stringWithFormat:@"%@.xls",m_strXlName];
    NSString *strNameXlsx =[NSString stringWithFormat:@"%@.xlsx",m_strXlName];
    NSString *name = xlsMode ? strNameXls:strNameXlsx;
    
    NSString *documentPath =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [documentPath stringByAppendingPathComponent:name];
    filename =  [isWriteToHaveAddr state] ? m_textPlistPath : filename;
    
    book = xlsMode ? xlCreateBook() : xlCreateXMLBook();
    xlBookLoad(book, [filename UTF8String]);
    boldFont = xlBookAddFont(book, 0);
    xlFontSetBold(boldFont, 2);
    redFont = xlBookAddFont(book, 0);
    xlFontSetColor(redFont,COLOR_RED);
    blueFont = xlBookAddFont(book, 0);
    xlFontSetColor(blueFont,COLOR_BLUE);
   // xlFontColor(blueFont);
    greenFormat = xlBookAddFormat(book, 0);
    xlFormatSetFillPattern(greenFormat, FILLPATTERN_SOLID);
    xlFormatSetPatternForegroundColor(greenFormat, COLOR_GREEN);
    yellowFormat = xlBookAddFormat(book, 0);
    xlFormatSetFillPattern(yellowFormat, FILLPATTERN_SOLID);
    xlFormatSetPatternForegroundColor(yellowFormat, COLOR_YELLOW);
    redFormat = xlBookAddFormat(book, 0);
    xlFormatSetFillPattern(redFormat, FILLPATTERN_SOLID);
    xlFormatSetPatternForegroundColor(redFormat, COLOR_RED);
    blueFormat = xlBookAddFormat(book, 0);
    xlFormatSetFillPattern(blueFormat, FILLPATTERN_SOLID);
    xlFormatSetPatternForegroundColor(blueFormat, COLOR_BLUE);
    greyFormat = xlBookAddFormat(book, 0);
    xlFormatSetFillPattern(greyFormat, FILLPATTERN_SOLID);
    xlFormatSetPatternForegroundColor(greyFormat, COLOR_GRAY40);
    grayWhiteFormat = xlBookAddFormat(book, 0);
    xlFormatSetFillPattern(grayWhiteFormat, FILLPATTERN_SOLID);
    xlFormatSetPatternForegroundColor(grayWhiteFormat, COLOR_GRAY25);
    pinkFormat = xlBookAddFormat(book, 0);
    xlFormatSetFillPattern(pinkFormat, FILLPATTERN_SOLID);
    xlFormatSetPatternForegroundColor(pinkFormat, COLOR_PINK);
    
    titleFormat = xlBookAddFormat(book, 0);
    xlFormatSetFillPattern(titleFormat, FILLPATTERN_SOLID);
    xlFormatSetPatternForegroundColor(titleFormat, COLOR_BRIGHTGREEN);
    blueFontFormat = xlBookAddFormat(book,0);
    xlFormatSetFont(blueFontFormat,blueFont);
    //sheet = xlBookAddSheet(book,[m_strSheetName UTF8String],nil);
    //sheet = xlBookInsertSheet (book,xlBookSheetCount(book), [m_strSheetName UTF8String], nil);
    //[self returnSheet:book];
    if ([isWriteToHaveAddr state]==1) {
    int iCount = xlBookSheetCount(book); //sheet count
    //get the sheet  by catched the Station name from UartLog
    for(int i = 0; i < iCount; i++)
    {
        sheet  = xlBookGetSheet(book,i);
        const char  * cSheetName   = xlSheetName(sheet);
        NSString    * strSheetName = [NSString stringWithUTF8String:cSheetName];
        strSheetName = [strSheetName stringByReplacingOccurrencesOfString:@" " withString:@""];
        m_strSheetName = [m_strSheetName stringByReplacingOccurrencesOfString:@" " withString:@""];
        if([[strSheetName uppercaseString] isEqualToString:[m_strSheetName uppercaseString]])
        {
            xlBookDelSheet(book,i);
            xlBookInsertSheet(book,i,[m_strSheetName UTF8String],nil);
            sheet  = xlBookGetSheet(book,i);
            break;
        }
        else if(i != iCount-1)
            continue;
        else
        {
            const char  * cSheetName = [m_strSheetName cStringUsingEncoding:NSUTF8StringEncoding];
            xlBookAddSheet(book, cSheetName, nil);
            sheet  = xlBookGetSheet(book,i+1);
            break;
        }
    }
    }
    else{
        sheet = xlBookAddSheet(book,[m_strSheetName UTF8String],nil);
    }
       if(sheet)
    {
        xlSheetWriteStr(sheet, 1, 0, "Color define", 0);

        xlSheetWriteStr(sheet, 6, 0, "", blueFormat);
        xlSheetWriteStr(sheet, 6, 1, "Fixture Mark Blue",0);

        xlSheetWriteStr(sheet, 8, 0, "CSV ct (s)", titleFormat);
        xlSheetWriteStr(sheet, 8, 1, "Related Test Item", titleFormat);
        xlSheetWriteStr(sheet, 8, 2, "Spec", titleFormat);
        xlSheetWriteStr(sheet, 8, 3, "Diags Command ", titleFormat);
        xlSheetWriteStr(sheet, 8, 4, "Command Length (char#)", titleFormat);
        xlSheetWriteStr(sheet, 8, 5, "Diags Response", titleFormat);
        xlSheetWriteStr(sheet, 8, 6, "Reponse Length (char#)", titleFormat);
        xlSheetWriteStr(sheet, 8, 7, "Total Length (char#)", titleFormat);
        xlSheetWriteStr(sheet, 8, 8, "Command Execution Time (s)", titleFormat);

        
        int i = 0;
        int j = 0;
        int J = 0;
        int length =0;
        NSString* str =[NSString string];
        NSString *strItemName = [NSString string];

//        for (NSArray *arr1 in arr) {
        for (NSDictionary *dic  in arr) {
            
            xlSheetWriteStr(sheet, 9+i, 1, "", 0);
            strItemName = [dic objectForKey:@"ItemName"];
           
            if(![strItemName isEqualToString: @""]){
                NSString *strCycleTime = (NSString*)[dicRoot objectForKey:strItemName];
                NSString *strFinalCycleTime = [NSString stringWithFormat:@"%@s",strCycleTime];
                xlSheetWriteStr(sheet, 9+i, 0, [strFinalCycleTime UTF8String], 0);
                xlSheetWriteStr(sheet, 9+i, 1, [strItemName UTF8String], 0);
                xlSheetWriteStr(sheet, 9+i, 2, [[dic objectForKey:@"Spec"]UTF8String],0);
                NSString *strSingleCommand =[dic objectForKey:@"Command"];
                NSString *strSingleReponse =[dic objectForKey:@"Response"];
                //int length =(int) [[strSingleReponse SubFrom:@"]):" include:NO]length];
                
                if ([strSingleCommand contains:@"TX ==> [FIXTURE]"]) {
           // xlSheetWriteStr(sheet, 9+i, 3, [strSingleCommand UTF8String], blueFontFormat);
                strSingleCommand = [strSingleCommand SubFrom:@"[FIXTURE]):" include:NO];
                xlSheetWriteStr(sheet, 9+i, 3, [strSingleCommand UTF8String], blueFontFormat);
                int k = (int )[strSingleCommand length];
                xlSheetWriteNum(sheet, 9+i, 4, k, 0);
                strSingleReponse = [[strSingleReponse SubFrom:@"RX ==> [FIXTURE]):" include:NO]SubTo:@"@_@" include:YES];
                xlSheetWriteStr(sheet, 9+i, 5, [strSingleReponse UTF8String], blueFontFormat);
                int K = (int) [strSingleReponse length];
                xlSheetWriteNum (sheet, 9+i, 6, K, 0);
                length =(k+K);

           // xlFontColor(blueFont);
            }else if([strSingleCommand contains:@"TX ==> [MOBILE]"]){
          //  xlSheetWriteStr(sheet, 9+i, 3, [strSingleCommand UTF8String], 0);
                strSingleCommand = [strSingleCommand SubFrom:@"[MOBILE]):" include:NO];
                xlSheetWriteStr(sheet, 9+i, 3, [strSingleCommand UTF8String], 0);
                int k = (int )[strSingleCommand length];
                xlSheetWriteNum(sheet, 9+i, 4, k, 0);
                strSingleReponse = [[strSingleReponse SubFrom:@"RX ==> [MOBILE]):" include:NO]SubTo:@" :-) " include:YES];
                xlSheetWriteStr(sheet, 9+i, 5, [strSingleReponse UTF8String], 0);
                int K = (int) [strSingleReponse length];
                xlSheetWriteNum(sheet, 9+i, 6, K, 0);
                 length =(k+K);

            }
                xlSheetWriteNum(sheet, 9+i, 7,length , 0);
                if ([dic objectForKey:@"DurationTime"]) {
                    xlSheetWriteStr(sheet, 9+i, 8,[[dic objectForKey:@"DurationTime"] UTF8String], 0);
                }
            }
       // }//合并单元格
            if (i>0 && [str isEqualToString:strItemName]){
                j++;
//                length+=length;
 //               xlSheetWriteNum(sheet, 9+J, 7,length, 0);
                
            }
            else{
                xlSheetSetMerge(sheet, 9+J, 8+j, 1, 1);
                xlSheetSetMerge(sheet, 9+J, 8+j, 2, 2);
                int x = (int) [[[[arr objectAtIndex:J] objectForKey:@"Response"] SubFrom:@"]):" include:NO]length] + (int) [[[[arr objectAtIndex:J] objectForKey:@"Command"] SubFrom:@"]):" include:NO]length];

                //for tatol time
                for(int y=9+J;y< 8+j;y++){
                    x =x+ (int) [[[[arr objectAtIndex:y-8] objectForKey:@"Response"] SubFrom:@"]):" include:NO]length]+(int) [[[[arr objectAtIndex:y-8] objectForKey:@"Command"] SubFrom:@"]):" include:NO]length];
                }
                xlSheetWriteNum(sheet, 9+J, 7,x, 0);
                xlSheetSetMerge(sheet, 9+J, 8+j, 7, 7);
                length =0;
                xlSheetSetMerge(sheet, 9+J, 8+j, 0, 0);

                J = j;
                j++;
            }
             str =[NSString stringWithString:strItemName];
            i++;
        }
        //

       // int iCow = xlsheetcol
        xlSheetSetCol(sheet, 1, 1, 40, 0, 0);
        xlSheetSetCol(sheet, 3, 3, 40, 0, 0);
        xlSheetSetCol(sheet, 5, 5, 40, 0, 0);
        xlSheetSetCol(sheet, 8, 8, 40, 0, 0);
        
    }
   //    NSString *name = xlsMode ? @"OTC.xls":@"OTC.xlxs";
    xlBookSave(book, [filename UTF8String]);
    
    xlBookRelease(book);
    
    [[NSWorkspace sharedWorkspace] openFile:filename];
    return YES;
    
}
- (IBAction)btnDo:(id)sender {
    BOOL xlsMode = [[excelFormat selectedCell] tag];
    if ([isWriteToHaveAddr state ]== 1) {
    NSOpenPanel	*openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseFiles:YES];		//Can choose file
    [openPanel setCanChooseDirectories:NO];	//Can't choose directories
    [openPanel setAllowsMultipleSelection:YES];	//Only can choose one file at one time
    NSString *name = xlsMode ? @"xls":@"xlsx";
    [openPanel setAllowedFileTypes:[NSArray arrayWithObject:name]];//set the file types that can be choosed
    
    //Get the file's URL
    NSString *strFilePath = @"~/";
    strFilePath = [strFilePath stringByExpandingTildeInPath];
    NSURL *fileURL = [NSURL fileURLWithPath:strFilePath];
  
    [openPanel setDirectoryURL:fileURL];
    [openPanel beginSheetModalForWindow:_window completionHandler:^(NSInteger result)
     {
         if(result == NSFileHandlingPanelOKButton)
         {
             for(NSURL *url in  [openPanel URLs])
             {
                 NSString *urlString = [NSString stringWithFormat:@"生成成功，路径是%@",[url path]];
                 m_textPlistPath = [url path];
                 
                if([self imformationFormat:xlsMode])
                [textTalk setStringValue:urlString];
             }
         }
     }];
    }
    else{
        if ([self imformationFormat:xlsMode]){
        NSString *strNameXls =[NSString stringWithFormat:@"%@.xls",m_strXlName];
        NSString *strNameXlsx =[NSString stringWithFormat:@"%@.xlsx",m_strXlName];
        NSString *name = xlsMode ? strNameXls:strNameXlsx;
        
        NSString *documentPath =
        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filename = [documentPath stringByAppendingPathComponent:name];
        NSString *urlString = [NSString stringWithFormat:@"生成成功，路径是%@",filename];
        [textTalk setStringValue:urlString];
        }
    }
}

- (IBAction)btnChoose:(id)sender {
    NSOpenPanel	*openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseFiles:YES];		//Can choose file
    [openPanel setCanChooseDirectories:NO];	//Can't choose directories
    [openPanel setAllowsMultipleSelection:YES];	//Only can choose one file at one time
    [openPanel setAllowedFileTypes:[NSArray arrayWithObject:@"txt"]];//set the file types that can be choosed
    
    //Get the file's URL
    NSString *strFilePath = @"~/";
    strFilePath = [strFilePath stringByExpandingTildeInPath];
    NSURL *fileURL = [NSURL fileURLWithPath:strFilePath];
    
    [openPanel setDirectoryURL:fileURL];
    [openPanel beginSheetModalForWindow:_window completionHandler:^(NSInteger result)
     {
         if(result == NSFileHandlingPanelOKButton)
         {
             for(NSURL *url in  [openPanel URLs])
             {
                 NSString *urlString = [url path];
                 [txtFilePath setStringValue:urlString];
             }
         }
     }];

}
-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender{
    return YES;
}
-(NSMutableDictionary*)getCycleTime:(NSString*)str{
    NSMutableDictionary *dicRoot = [NSMutableDictionary dictionary];
    NSString * strFileContents = [NSString stringWithContentsOfFile:str encoding:NSUTF8StringEncoding
                                  error:nil];
    if (strFileContents){
        NSArray *aryItems = [strFileContents componentsSeparatedByString:@"\n"];
        for (NSUInteger i = 0; i < [aryItems count]; i++){
            NSString * strItem = [aryItems objectAtIndex:i];
            NSArray * aryValue = [strItem componentsSeparatedByString:@","];
            NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[\"]" options:0 error:NULL];
            //  NSString *string = @"a:!@#$%^&*();'/?><,_=+{}|-123-45b78";
            NSString *result0 = [regular stringByReplacingMatchesInString:[aryValue objectAtIndex:0] options:0 range:NSMakeRange(0, [[aryValue objectAtIndex:0]  length]) withTemplate:@""];
            NSString *result5 = [regular stringByReplacingMatchesInString:[aryValue objectAtIndex:5] options:0 range:NSMakeRange(0, [[aryValue objectAtIndex:5]  length]) withTemplate:@""];
            //  [m_ArRootArray addObject:[aryValue objectAtIndex:5]];
            [dicRoot setObject:result5 forKey:result0];
            }
    }
    return dicRoot;
}
- (void)UpdateUI:(NSString *)str {
      [textTalk setStringValue:str];
  
    }

@end
