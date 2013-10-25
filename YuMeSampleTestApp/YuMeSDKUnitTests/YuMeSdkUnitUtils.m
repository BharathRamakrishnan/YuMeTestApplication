//
//  YuMeSdkUnitUtils.m
//  YuMeiOSSDK
//
//  Created by Bharath Ramakrishnan on 9/5/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "YuMeSdkUnitUtils.h"

@implementation YuMeSdkUnitUtils

BOOL bIsEventFired = NO;
NSCondition *waitForEvent;
NSString *waitForEventName;
NSString *waitForResponeEventName;
NSMutableDictionary *csvTestCases;

NSString *fileName = @"yume_debug_log.txt";

+ (void) init {
    pYuMeTestInterface = nil;
    videoController = nil;
    yumeSDK = nil;
    pError = nil;
    resultArray = nil;
    csvTestCases = nil;
}

/*
 * Get the YuMeInterface object
 */
+ (YuMeInterface *) getYuMeInterface {
    YuMeInterface *pYuMeInterface = [[YuMeInterface alloc] init];
    return pYuMeInterface;
}

/*
 * Get the Application YuMe Ad Params object
 */
+ (YuMeAdParams *) getApplicationYuMeAdParams {
    AppSettings *settings = [AppSettings readSettings];
    if (settings == nil) {
        return nil;
    }

    YuMeAdParams *params = [[YuMeAdParams alloc] init];
    params.pAdServerUrl = settings.adServerURL;
    params.pDomainId = settings.domain;
    params.pAdditionalParams = settings.params;
    params.adTimeout = [settings.adTimeOut intValue];
    params.videoTimeout = [settings.playTimeOut intValue];
    params.storageSize = [settings.diskQuto floatValue];
    params.bEnableAutoPrefetch = settings.isautoPrefetchEnabled;
    params.bEnableCaching = settings.iscachingEnabled;
    params.bEnableCBToggle = settings.isEnabledControlBar;
    params.bSupportAutoNetworkDetect = settings.isAutoSpeedDetect;
    params.bSupportHighBitRate = settings.isHighBitrate;
    params.bOverrideOrientation = settings.isOverrideOrientation;
    params.ePlayType = settings.playTypeEnum;
    return params;
}

+ (void) readTestDatafromCSV {
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"YuMeSDKTestData" ofType:@"csv"];
    NSString *strFile = [NSString stringWithContentsOfFile:strPath encoding:NSUTF8StringEncoding error:nil];
    if (!strFile) {
        NSLog(@"Error reading file.");
    }
    csvTestCases = [[NSMutableDictionary alloc] init];
    NSArray *testCases = [strFile componentsSeparatedByString:@"\n"];
    for (NSString *testId in testCases) {
        NSArray *singleCase = [testId componentsSeparatedByString:@","];
        [csvTestCases setObject:singleCase forKey:[singleCase objectAtIndex:0]];
    }    
}

+ (YuMeAdParams *) getTestCaseYuMeAdParms:(NSString *)testId {
    if (csvTestCases == nil) {
        [YuMeSdkUnitUtils readTestDatafromCSV];
    }
    
    NSArray *csvObject = [csvTestCases objectForKey:testId];
    YuMeAdParams *params = nil;
    if (csvObject) {
        params = [[YuMeAdParams alloc] init];
        params.pAdServerUrl = [NSString stringWithFormat:@"%@", [csvObject objectAtIndex:1]];
        params.pDomainId = [csvObject objectAtIndex:2];
        params.pAdditionalParams = [csvObject objectAtIndex:3];
        params.adTimeout = [[csvObject objectAtIndex:4] intValue];
        params.videoTimeout = [[csvObject objectAtIndex:5] intValue];
        params.storageSize = [[csvObject objectAtIndex:13] floatValue];
        params.bEnableAutoPrefetch = [[csvObject objectAtIndex:12] boolValue];
        params.bEnableCaching = [[csvObject objectAtIndex:11] boolValue];
        params.bEnableCBToggle = [[csvObject objectAtIndex:14] boolValue];
        params.bSupportAutoNetworkDetect = [[csvObject objectAtIndex:10] boolValue];
        params.bSupportHighBitRate = [[csvObject objectAtIndex:9]boolValue];
        params.bOverrideOrientation = [[csvObject objectAtIndex:21] boolValue];
    } else {
        // Remove this else block once csv file fully modified
        AppSettings *settings = [AppSettings readSettings];
        if (settings == nil) {
            return nil;
        }
        
        params = [[YuMeAdParams alloc] init];
        params.pAdServerUrl = settings.adServerURL;
        params.pDomainId = settings.domain;
        params.pAdditionalParams = settings.params;
        params.adTimeout = [settings.adTimeOut intValue];
        params.videoTimeout = [settings.playTimeOut intValue];
        params.storageSize = [settings.diskQuto floatValue];
        params.bEnableAutoPrefetch = settings.isautoPrefetchEnabled;
        params.bEnableCaching = settings.iscachingEnabled;
        params.bEnableCBToggle = settings.isEnabledControlBar;
        params.bSupportAutoNetworkDetect = settings.isAutoSpeedDetect;
        params.bSupportHighBitRate = settings.isHighBitrate;
        params.bOverrideOrientation = settings.isOverrideOrientation;
        params.ePlayType = settings.playTypeEnum;
    }
    return params;
}

+ (NSString *) getStatusString {
    return waitForResponeEventName;
}

/*
// Override any exceptions; By default exceptions are raised, causing a test failure
+ (void)failWithException:(NSException *)exception {
    NSLog(@">>>>>> %@", exception.description);
    //GHFail(exception.description);
    
    [self handleException:exception];
}

+ (void)handleException:(NSException *)exception {
    NSLog(@">handleException>>>> %@", exception.description);
    GHFail(exception.description);
}*/


/*
 * Get the NSError userInfo Object.
 */
+ (NSString *) getErrDesc:(NSError *)pError {
	NSString *errStr = [[pError userInfo] valueForKey:NSLocalizedDescriptionKey];
	return [[errStr copy] autorelease];
}


+ (NSError *) callYuMeSDKInit:(NSString *)testId {
    NSLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    /*
    GHAssertNotNil(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHAssertNotNil(yumeSDK, @"yumeSDK object not found");
    
    pError = nil;
    YuMeAdParams *params = [YuMeSdkUnitUtils getTestCaseYuMeAdParms:testId];
    params.pAdServerUrl = EMPTY_VALID_PL;
    GHAssertNotNULL(params, @"params object not found");
    
    if (videoController) {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                      videoPlayerDelegate:videoController
                                errorInfo:&pError], @"Initialization Successful.");
    } else {
        GHAssertTrue([yumeSDK yumeSdkInit:params
                              appDelegate:pYuMeTestInterface
                                errorInfo:&pError], @"Initialization Successful.");
    }
    [params release];
    */
    return pError;
}

/*
 * Listens the yumeEventListener of expected value.
 */
+ (BOOL) yumeEventListener:(NSString *)adState yumeSdkInterface:(YuMeInterface *)pYuMeTestInterface interval:(NSInteger)duration {
    static BOOL bValue = FALSE;
    [YuMeSdkUnitUtils waitForCompletion:duration];
    
    NSString *adStatus = pYuMeTestInterface.currentAdStaus;
    
    if([adStatus isEqualToString:adState]) {
        bValue = TRUE;
        return bValue;
    } else if ([adState isEqualToString:@"YuMeAdEventAdReady"]) {
        if ([adStatus isEqualToString:@"YuMeAdEventAdAndAssetsReady"] || [adStatus isEqualToString:@"YuMeAdEventPartialAssetsReady"]) {
            bValue = TRUE;
            return bValue;
        }
    }
    
    [YuMeSdkUnitUtils yumeEventListener:adState yumeSdkInterface:pYuMeTestInterface interval:duration];
    
    return bValue;
}

/*
 * Return the true value after the time interval exists.
 */
+ (BOOL) waitForCompletion:(NSTimeInterval)timeoutSecs {
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSecs];
    BOOL done = false;
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        if ([timeoutDate timeIntervalSinceNow] < 0.0) {
            break;
        }
    }
    while (!done);
    return done;
}

+ (void) receiveYuMeEventListener:(NSNotification *)notification {
    NSLog(@"Reqeust: %@ \n Response: %@", waitForEventName , notification.object);
    
    if ([[notification name] isEqualToString:@"yumeEventListener"]) {
        waitForResponeEventName = (NSString *)notification.object;
        
        NSLog (@"Successfully received the notification : %@", notification.object);
        if ([waitForEventName isEqualToString:notification.object]) {
            [waitForEvent lock];
            bIsEventFired = YES;

            [waitForEvent signal];

            [YuMeSdkUnitUtils yumeEventListenerLock:nil];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        } else {
            // Error response
        }
    }
}

+ (BOOL) yumeEventListenerLock:(NSString *)eventName {
    if (eventName != nil) {
        if (waitForEvent)
            [waitForEvent release];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveYuMeEventListener:) name:@"yumeEventListener" object:nil];
        waitForEvent = [[NSCondition alloc] init];
        waitForEventName = eventName;
        bIsEventFired = NO;
        [waitForEvent lock];
    }
    
    while (!bIsEventFired)
    {
        [waitForEvent wait];
    }
    [waitForEvent unlock];
    
    return TRUE;
}

+ (NSString *) logString:(NSString *)aString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    NSDate *dt = [NSDate date];
    NSString *timeString = [NSString stringWithFormat:@"%@: ", [dateFormatter stringFromDate:dt]];
    timeString = [timeString stringByAppendingString:aString];
    [dateFormatter release]; dateFormatter = nil;
    return timeString;
}

+ (void) createTestReport:(NSMutableArray *)results title:(NSString *)titleString {

    NSMutableString *htmlText = [[NSMutableString alloc] init];
    [htmlText appendFormat: @"<HTML><HEAD><TITLE>TEST</TITLE></HEAD>"];
    [htmlText appendFormat: @"<BODY>"];
    
    YuMeInterface *yumeInterface = [self getYuMeInterface];
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"dd-MMMM-yyyy HH:mm"];
    NSString *formattedDate = [formatter stringFromDate: today];

    [htmlText appendFormat: @"<P><B><U><CENTER><FONT face=Verdana color=#0489B1 size=4>iOS UseCase Automation Test Report: %@</FONT></CENTER></U></B></P><P><B><FONT face=Verdana color=#151515 size=2>Date:</B>%@</FONT></P><P><B><FONT face=Verdana color=#151515 size=2>SDK Version:</B>%@</FONT></P><P><B><FONT face=Verdana color=#151515 size=2>Test Device:</b>%@</font></P>", titleString, formattedDate, [yumeInterface yumeGetVersion], [[UIDevice currentDevice] model]];
    
    [htmlText appendFormat:@"<style type='text/css'>.table{ width:500px; border: 1px solid #ccc; white-space: normal;}.table td{ border: 1px solid #ccc;}</style>"];
    
    [htmlText appendFormat: @"<TABLE class='table' borderColorLight=#008080 border=2>&nbsp"];
    [htmlText appendFormat: @"<TR>"];
    [htmlText appendFormat: @"<TH>S.No</TH>"];
    [htmlText appendFormat: @"<TH>Usecase_ID</TH>"];
    [htmlText appendFormat: @"<TH>Pre-conditions</TH>"];
    [htmlText appendFormat: @"<TH>Usecase</TH>"];
    [htmlText appendFormat: @"<TH>Expected SDK Behavior</TH>"];
    [htmlText appendFormat: @"<TH>Status</TH>"];
    [htmlText appendFormat: @"</TR>"];
    
    int i = 0;
    for ( NSMutableDictionary *resultDict in resultArray) {
        i++;
        NSString *sno = [NSString stringWithFormat:@"<TR><TD align='center' bgColor=#F2F2F2>%d</TD>", i];
        NSString *testCaseId = [NSString stringWithFormat:@"<TD align='left' bgColor=#F2F2F2>%@</TD>", [resultDict valueForKey:@"testCaseId"]];
        NSString *preCondition = [NSString stringWithFormat:@"<TD align='left' width=80 bgColor=#F2F2F2>%@</TD>", [resultDict valueForKey:@"preCondition"]];
        NSString *useCase = [NSString stringWithFormat:@"<TD align='left' width=80 bgColor=#F2F2F2>%@</TD>", [resultDict valueForKey:@"useCase"]];
        NSString *expectedBehaviour = [NSString stringWithFormat:@"<TD align='left' width=80 bgColor=#F2F2F2>%@</TD>", [resultDict valueForKey:@"status"]];
        NSString *result = @"";
        if ([[resultDict valueForKey:@"result"] isEqualToString:@"Pass"]) {
            result = [NSString stringWithFormat:@"<TD align='left' bgColor=#F2F2F2><font color=green>%@</font></TD></TR>", [resultDict valueForKey:@"result"]];
        } else {
            result = [NSString stringWithFormat:@"<TD align='left' bgColor=#F2F2F2><font color=red>%@</font></TD></TR>", [resultDict valueForKey:@"result"]];
        }
        NSString *singleRow = [NSString stringWithFormat:@"%@%@%@%@%@%@",sno, testCaseId, preCondition, useCase, expectedBehaviour, result];
        [htmlText appendFormat: @"%@", singleRow];
    }
    
    [htmlText appendFormat: @"</TABLE>"];
    [htmlText appendFormat: @"</BODY>"];
    [htmlText appendFormat: @"</HTML>"];
    
    // create the file
    NSError *error = nil;
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"result" ofType:@"html"];
    [htmlText writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        // do some stuff
    }
    
    NSString *filename = [NSString stringWithFormat:@"tmp/YuMe_Report_%@.html", titleString];
    
    NSURL *htmlURL = [NSURL fileURLWithPath:filePath];
    NSFileManager *fileManager =[NSFileManager defaultManager];
    NSString *fileName = [NSHomeDirectory() stringByAppendingPathComponent:filename];
    NSData *data = [[NSData alloc] initWithContentsOfURL:htmlURL];
    BOOL filecreationSuccess = [fileManager createFileAtPath:fileName contents:data attributes:nil];
    if(filecreationSuccess == NO){
        NSLog(@"Failed to create the html file");
    }
    [data release];
    
    [htmlText release]; htmlText = nil;
    // clear the result array
    if (resultArray) {
        [resultArray release]; resultArray = nil;
    }
}

/*
 * Creates the console Log file.
 */
+ (void) createConsoleLogFile {
    // delete previos file
    [YuMeSdkUnitUtils deleteConsoleLogFile];
    
    NSString *logFilePath = [YuMeSdkUnitUtils getConsoleLogFilePath];
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}

/*
 * Read the console Log file.
 */
+ (NSString *) readConsoleLogFile {
    NSString *content = [NSString stringWithContentsOfFile:[YuMeSdkUnitUtils getConsoleLogFilePath]
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    return content;
}

/*
 * Delete the console Log file.
 */
+ (void) deleteConsoleLogFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [YuMeSdkUnitUtils getConsoleLogFilePath];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (!success) {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

/*
 * Get the console log file path
 */
+ (NSString *)getConsoleLogFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	if (!documentsDirectory) {
		NSLog(@"Documents directory not found!");
		return nil;
	}
	return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+ (void) createTestCase:(NSMutableDictionary *)testCaseObj testCaseId:(NSString *)testId preCondition:(NSString *)condition useCase:(NSString *)usecase {
    
    if (resultArray == nil)
        resultArray = [[NSMutableArray alloc] init];

    if (testCaseObj) {
        [testCaseObj setObject:testId forKey:@"testCaseId"];
        [testCaseObj setObject:condition forKey:@"preCondition"];
        [testCaseObj setObject:usecase forKey:@"useCase"];
    }
}

+ (void) closeTestCase:(NSMutableDictionary *)testCaseObj status:(NSString *)status result:(NSString *)result {
    if (testCaseObj) {
        [testCaseObj setObject:status forKey:@"status"];
        [testCaseObj setObject:result forKey:@"result"];
        [resultArray addObject:testCaseObj];
    }
}

@end
