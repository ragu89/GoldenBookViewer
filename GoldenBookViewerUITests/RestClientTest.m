//
//  RestClientTest.m
//  GoldenBookViewer
//
//  Created by Guye, Raphael on 19.03.17.
//  Copyright © 2017 Guye, Raphael. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RestClient.h"
#import "Ad.h"

@interface RestClientTest : XCTestCase

@end

@implementation RestClientTest

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetAds
{
    XCTestExpectation *openExpectation = [self expectationWithDescription:@"test 1"];
    
    [[RestClient sharedInstance] getAdsWithCompletionHandler:^(NSArray *ads, NSError *error)
    {
        XCTAssertNotNil(ads);
        XCTAssertTrue(ads.count > 0);
        
        for(Ad *ad in ads)
        {
            XCTAssertTrue((ad.name != nil && [ad.name isKindOfClass:[NSString class]] && ad.name.length > 0)
                          || (ad.photoId != nil && [ad.photoId isKindOfClass:[NSString class]] && ad.photoId.length > 0)
                          || (ad.message != nil && [ad.message isKindOfClass:[NSString class]] && ad.message.length > 0));
        }
        
        [openExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        // Timeout
    }];
}

@end
