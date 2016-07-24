//
// Created by Филипп Панфилов on 21/07/16.
// Copyright (c) 2016 test. All rights reserved.
//

#import "NSDecimalNumber+EXC.h"


@implementation NSDecimalNumber (EXC)

- (NSString *)exc_stringValueWithCurrencyCode:(NSString *)currencyCode {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:currencyCode];
    NSString *formattedPrice = [numberFormatter stringFromNumber:self];
    return formattedPrice;
}

@end