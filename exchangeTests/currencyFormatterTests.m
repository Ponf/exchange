//
//  currencyFormatterTests.m
//  currencyFormatterTests
//
//  Created by Филипп Панфилов on 20/07/16.
//  Copyright © 2016 test. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+EXC.h"

@interface currencyFormatterTests : XCTestCase

@end

@implementation currencyFormatterTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testShortNumber {
    NSString *inputString = @"1.10";
    NSAttributedString *attributedString = [inputString exc_beautifulAmountString];
    XCTAssert([attributedString.string isEqualToString:@"1.10"]);
}

- (void)testLongNumber {
    NSString *inputString = @"12.43525235";
    NSAttributedString *attributedString = [inputString exc_beautifulAmountString];
    XCTAssert([attributedString.string isEqualToString:@"12.43"]);
}

- (void)testSeveralSeparators {
    NSString *inputString = @"12.34.56";
    NSAttributedString *attributedString = [inputString exc_beautifulAmountString];
    XCTAssert(attributedString == nil);
}

- (void)testSignedValue {
    NSString *inputString = @"-12.34";
    NSAttributedString *attributedString = [inputString exc_beautifulAmountString];
    XCTAssert([attributedString.string isEqualToString:inputString]);
}

- (void)testSavingSeparator {
    NSString *inputString = @"12.";
    NSAttributedString *attributedString = [inputString exc_beautifulAmountString];
    XCTAssert([attributedString.string isEqualToString:inputString]);
}

- (void)testWithoutSeparator {
    NSString *inputString = @"12";
    NSAttributedString *attributedString = [inputString exc_beautifulAmountString];
    XCTAssert([attributedString.string isEqualToString:inputString]);
}

- (void)testDecimalPart {
    NSString *inputString = @".34";
    NSAttributedString *attributedString = [inputString exc_beautifulAmountString];
    XCTAssert([attributedString.string isEqualToString:@"0.34"]);
}

- (void)testWrongSign {
    NSString *inputString = @"1-2.34";
    NSAttributedString *attributedString = [inputString exc_beautifulAmountString];
    XCTAssert(attributedString == nil);
}


@end
