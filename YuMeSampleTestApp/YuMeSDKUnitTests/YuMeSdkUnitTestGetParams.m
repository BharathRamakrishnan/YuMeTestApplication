//
//  YuMeSdkUnitTestGetParams.m
//  YuMeiOSTestApp
//
//  Created by Bharath Ramakrishnan on 9/18/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import "YuMeSdkUnitTestGetParams.h"
#import "YuMeSdkUnitUtils.h"

@implementation YuMeSdkUnitTestGetParams

- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
    // Also an async test that calls back on the main thread, you'll probably want to return YES.
    return NO;
}

- (void)setUpClass {
    // Run at start of all tests in the class
    NSLog(@"######################## RUN START - SetUpClass #######################################");
    
}

- (void)tearDownClass {
    // Run at end of all tests in the class
    NSLog(@"######################## RUN END - TeatDownClass #######################################");
}

- (void)setUp {
    // Run before each test method
    NSLog(@"************************ Unit Test - SetUp ************************");
    
    pYuMeTestInterface = [YuMeSdkUnitUtils getYuMeInterface];
    
    if(kUSE_OWN_VIDEOPLAYER) {
        if(videoController == nil)
            videoController = [[VideoPlayerController alloc] init];
    }
    
    if (pYuMeTestInterface)
        yumeSDK = [pYuMeTestInterface getYuMeSDKHandle];
    
    if (testCaseResult == nil)
        testCaseResult = [[NSMutableDictionary alloc] init];
    
}

- (void)tearDown {
    // Run after each test method
    if (yumeSDK) {
        [yumeSDK yumeSdkDeInit:&pError];
    }
    
    if (pYuMeTestInterface) {
        [pYuMeTestInterface release]; pYuMeTestInterface = nil;
    }
    
    if (kUSE_OWN_VIDEOPLAYER) {
        [videoController release]; videoController = nil;
    }
    
    if (testCaseResult) {
        [testCaseResult release]; testCaseResult = nil;
    }

    pError = nil;
    
    NSLog(@"************************ Unit Test - TearDown ************************");
}

// Override any exceptions; By default exceptions are raised, causing a test failure
- (void)failWithException:(NSException *)exception {
    
}

/* Pre conditions */
// SDK State: Not Initialized

/* Usecase */
// Called when SDK is not initialized.

/* Expected behavior */
// 1. Throws Exception: "YuMeSDK_GetAdParams(): YuMe SDK is not Initialized."
- (void)testUseCase_GetParams001 {
    
    // Create the resultArray
    if (resultArray)
        [resultArray release]; resultArray = nil;
    
    if (resultArray == nil)
        resultArray = [[NSMutableArray alloc] init];
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Not Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is not initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [yumeSDK yumeSdkGetAdParams:&pError];
    GHAssertTrue(params == nil, @"yumeSdkGetAdParams not Successful.");
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        GHAssertEqualObjects(str, @"yumeSdkGetAdParams(): YuMe SDK is not Initialized.", @"");
        GHTestLog(@"Result : %@", str);
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    } else {
        NSString *str = @"Throws Exception Problem : yumeSdkGetAdParams(): YuMe SDK is not Initialized.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    }
}
    

/* Pre conditions */
// SDK State: Initialized

/* Usecase */
// Called when SDK is initialized.

/* Expected behavior */
// 1. Returns the YuMeAdParams object.
- (void)testUseCase_GetParams002 {
    
    [testCaseResult setObject:NSStringFromSelector(_cmd) forKey:@"testCaseId"];
    [testCaseResult setObject:@"SDK State: Initialized" forKey:@"preCondition"];
    [testCaseResult setObject:@"Called when SDK is initialized." forKey:@"useCase"];

    GHAssertNotNULL(pYuMeTestInterface, @"pYuMeInterface object not found");
    GHTestLog(@"pYuMeTestInterface: %@", pYuMeTestInterface);
    
    GHAssertNotNULL(yumeSDK, @"yumeSDK object not found");
    GHTestLog(@"yumeSDK: %@", yumeSDK);
    
    YuMeAdParams *params = [YuMeSdkUnitUtils getApplicationYuMeAdParams];
    GHAssertNotNULL(params, @"params object not found");
    GHTestLog(@"params: %@", params);

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
    GHTestLog(@"Initialization Successful.");
    [params release];
    
    YuMeAdParams *adParams = [yumeSDK yumeSdkGetAdParams:&pError];
    if (adParams) {
        NSString *paramText = [NSString stringWithFormat:@"adServerUrl: %@ \ndomainId: %@ \nqsParams: %@ \nadTimeout: %d \nvideoTimeout: %d \nbSupportAutoNetworkDetect: %d \nbEnableCaching: %d \nbEnableAutoPrefetch: %d \nstorageSize: %f \nbEnableCBToggle: %d \nbSurvey: %d \nbOverrideOrientation: %d \nePlayType: %d  \nbEnableTTC: %d \nbAutoPlayStreamingAds: %d", adParams.pAdServerUrl, adParams.pDomainId, adParams.pAdditionalParams , adParams.adTimeout , adParams.videoTimeout , adParams.bSupportAutoNetworkDetect, adParams.bEnableCaching, adParams.bEnableAutoPrefetch, adParams.storageSize, adParams.bEnableCBToggle, adParams.bSupportSurvey , adParams.bOverrideOrientation, adParams.ePlayType, adParams.bEnableTTC, adParams.bAutoPlayStreamingAds];

        GHTestLog(@"YuMeSDK_GetAdParams : \n %@", paramText);
        GHAssertTrue((TRUE), @"YuMeSDK_GetAdParams(): Success.");
    }
    
    if (pError) {
        NSString *str = [YuMeSdkUnitUtils getErrDesc:pError];
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Fail" forKey:@"result"];
        [resultArray addObject:testCaseResult];
        [super failWithException:[NSException exceptionWithName:NSStringFromSelector(_cmd) reason:str userInfo:nil]];
    } else {
        NSString *str = @"yumeSdkGetAdParams Successful.";
        [testCaseResult setObject:str forKey:@"status"];
        [testCaseResult setObject:@"Pass" forKey:@"result"];
        [resultArray addObject:testCaseResult];
    }

    
#if kTEST_REPORT
    [YuMeSdkUnitUtils createTestReport:resultArray title:@"Getting Ad Params"];
#endif

}

@end
