//
//  YuMeSdkUnitUtils.h
//  YuMeiOSSDK
//
//  Created by Bharath Ramakrishnan on 9/5/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GHUnitIOS/GHUnit.h>
#import "AppSettings.h"
#import "YuMeInterface.h"
#import "YuMeSdkConstant.h"

@interface YuMeSdkUnitUtils : GHTestCase

+ (void) init;

+ (void) readTestDatafromCSV;

+ (YuMeInterface *) getYuMeInterface;

+ (YuMeAdParams *) getApplicationYuMeAdParams;

+ (YuMeAdParams *) getTestCaseYuMeAdParms:(NSString *)testId;

+ (NSError *) callYuMeSDKInit:(NSString *)testId;

+ (NSString *) getErrDesc:(NSError *)pError;

+ (BOOL) yumeEventListener:(NSString *)adState yumeSdkInterface:(YuMeInterface *)pYuMeTestInterface interval:(NSInteger)duration;

+ (BOOL) waitForCompletion:(NSTimeInterval)timeoutSecs;

+ (void) receiveYuMeEventListener:(NSNotification *)notification;

+ (BOOL) yumeEventListenerLock:(NSString *)eventName;

+ (NSString *) getStatusString;

+ (NSString *) logString:(NSString *)aString;

+ (void) createTestReport:(NSMutableArray *)results title:(NSString *)titleString;

//+ (void) yumeEventListenerUnLock;

+ (void) createConsoleLogFile;

+ (NSString *) readConsoleLogFile;

+ (void) deleteConsoleLogFile;

+ (NSString *)getConsoleLogFilePath;

+ (void) createTestCase:(NSMutableDictionary *)testCaseObj testCaseId:(NSString *)testId preCondition:(NSString *)condition useCase:(NSString *)usecase;

+ (void) closeTestCase:(NSMutableDictionary *)testCaseObj status:(NSString *)status result:(NSString *)result;


@end
