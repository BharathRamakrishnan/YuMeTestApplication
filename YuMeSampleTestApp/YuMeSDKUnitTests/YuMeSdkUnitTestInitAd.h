//
//  YuMeSdkUnitTestInitAd.h
//  YuMeiOSSDK
//
//  Created by Bharath Ramakrishnan on 9/11/13.
//  Copyright (c) 2013 YuMe Advertising Pvt. Ltd.,. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

@interface YuMeSdkUnitTestInitAd : GHAsyncTestCase {
    NSMutableDictionary *testCaseResult;
}

- (void) initEventListener:(NSArray *)userInfo;

- (void)testUseCase_InitAd001;
- (void)testUseCase_InitAd004;
- (void)testUseCase_InitAd005;


@end
