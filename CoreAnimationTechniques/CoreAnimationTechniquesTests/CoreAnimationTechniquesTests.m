//
//  CoreAnimationTechniquesTests.m
//  CoreAnimationTechniquesTests
//
//  Created by app-01 on 2017/2/4.
//  Copyright © 2017年 EBOOK. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface CoreAnimationTechniquesTests : XCTestCase

@end

@implementation CoreAnimationTechniquesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}
void (^loadImage)(NSString *imageName) = ^(NSString *imageName) {
    UIImage *image = [UIImage imageNamed:imageName];
};
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        loadImage(@"IMG_k1");
        loadImage(@"IMG_k2");
        loadImage(@"IMG_k3");
        loadImage(@"IMG_k4");
    }];
}
- (void)testLoadABigImage {
    [self measureBlock:^{
        loadImage(@"IMG_0263");
    }];
}
@end
