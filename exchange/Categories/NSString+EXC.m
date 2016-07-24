//
// Created by Филипп Панфилов on 21/07/16.
// Copyright (c) 2016 test. All rights reserved.
//

#import "NSString+EXC.h"
#import "NSDecimalNumber+EXC.h"
#import <UIKit/UIKit.h>


@implementation NSString (EXC)


- (NSAttributedString *)exc_beautifulAmountString {
    NSMutableAttributedString *resultAttributedString = [NSMutableAttributedString new];
    NSString *separatorString = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];
    NSString *signString = [self substringWithRange:NSMakeRange(0, 1)];

    NSArray *substrings = [[self substringFromIndex:1] componentsSeparatedByString:separatorString];
    NSCAssert((substrings.count > 0 && substrings.count < 3), @"Wrong input amount: too much decimal separators");
    if (!(substrings.count > 0 && substrings.count < 3)) {
        return nil;
    }

    NSString *integerPart = [substrings firstObject];
    if (integerPart.length == 0) {
        integerPart = @"0";
    }

    NSString *decimalPart = nil;
    if (substrings.count > 1) {
        decimalPart = [substrings lastObject];
        if (decimalPart.length > 2) {
            decimalPart = [decimalPart substringWithRange:NSMakeRange(0, 2)];
        }
    }

    if (integerPart) {
        UIFont *largeFont = [UIFont systemFontOfSize:32 weight:UIFontWeightLight];
        NSDictionary *largeFontStyles = @{NSFontAttributeName : largeFont,
                                          NSForegroundColorAttributeName : [UIColor whiteColor]};
        integerPart = [signString stringByAppendingString:integerPart];
        if (decimalPart) {
            integerPart = [integerPart stringByAppendingString:separatorString];
        }
        NSMutableAttributedString *integerAttributedPart = [[NSMutableAttributedString alloc] initWithString:integerPart
                                                                                                  attributes:largeFontStyles];
        [resultAttributedString appendAttributedString:integerAttributedPart];
    }

    if (decimalPart) {
        UIFont *smallFont = [UIFont systemFontOfSize:24 weight:UIFontWeightLight];
        NSDictionary *smallFontStyles = @{NSFontAttributeName : smallFont,
                                          NSForegroundColorAttributeName : [UIColor whiteColor]};
        NSMutableAttributedString *decimalAttributedPart = [[NSMutableAttributedString alloc]initWithString:decimalPart
                                                                                                 attributes:smallFontStyles];
        [resultAttributedString appendAttributedString:decimalAttributedPart];
    }

    return resultAttributedString.copy;
}

+ (NSAttributedString *)exc_beautifulExchangeRateStringFromCurrency:(NSString *)fromCurrency
                                                         toCurrency:(NSString *)toCurrency
                                                             amount:(NSDecimalNumber *)amount {
    NSMutableAttributedString *resultAttributedString = [NSMutableAttributedString new];
    NSInteger totalLength = [amount stringValue].length;
    NSString *smallResultPart = nil;
    if (totalLength > 4) {
        smallResultPart = [[amount stringValue] substringWithRange:NSMakeRange(4, totalLength - 4 < 2 ? 1 : 2)];
    }
    NSAttributedString *largeAttributedPart = [self exc_shortBeautifulExchangeStringFromCurrency:fromCurrency
                                                                                      toCurrency:toCurrency
                                                                                          amount:amount];

    [resultAttributedString appendAttributedString:largeAttributedPart];

    if (smallResultPart) {
        UIFont *smallFont = [UIFont systemFontOfSize:13];
        NSDictionary *smallFontStyles = @{NSFontAttributeName : smallFont,
                NSForegroundColorAttributeName : [UIColor whiteColor]};
        NSMutableAttributedString *smallAttributedPart = [[NSMutableAttributedString alloc] initWithString:smallResultPart
                                                                                                  attributes:smallFontStyles];
        [resultAttributedString appendAttributedString:smallAttributedPart];
    }

    return resultAttributedString.copy;
}

+ (NSAttributedString *)exc_shortBeautifulExchangeStringFromCurrency:(NSString *)fromCurrency
                                                                 toCurrency:(NSString *)toCurrency
                                                                     amount:(NSDecimalNumber *)amount {
    NSString *amountWithSign = [amount exc_stringValueWithCurrencyCode:toCurrency];
    NSString *largeResultPart = [amountWithSign substringWithRange:NSMakeRange(0,5)];
    NSString *fromString = [[[NSDecimalNumber alloc] initWithString:@"1"] exc_stringValueWithCurrencyCode:fromCurrency];
    largeResultPart = [NSString stringWithFormat:@"%@ = %@", [fromString substringWithRange:NSMakeRange(0,2)], largeResultPart];

    UIFont *largeFont = [UIFont systemFontOfSize:16];
    NSDictionary *largeFontStyles = @{NSFontAttributeName : largeFont,
            NSForegroundColorAttributeName : [UIColor whiteColor]};
    NSMutableAttributedString *largeAttributedPart = [[NSMutableAttributedString alloc] initWithString:largeResultPart
                                                                                              attributes:largeFontStyles];
    return [largeAttributedPart copy];
}


@end