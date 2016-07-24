//
// Created by Филипп Панфилов on 21/07/16.
// Copyright (c) 2016 test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EXC)

- (NSAttributedString *)exc_beautifulAmountString;

+ (NSAttributedString *)exc_beautifulExchangeRateStringFromCurrency:(NSString *)fromCurrency
                                                         toCurrency:(NSString *)toCurrency
                                                             amount:(NSDecimalNumber *)amount;

+ (NSAttributedString *)exc_shortBeautifulExchangeStringFromCurrency:(NSString *)fromCurrency toCurrency:(NSString *)toCurrency amount:(NSDecimalNumber *)amount;
@end