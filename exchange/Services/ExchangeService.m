//
// Created by Филипп Панфилов on 21/07/16.
// Copyright (c) 2016 test. All rights reserved.
//

#import "ExchangeService.h"
#import "NetworkingService.h"


@implementation ExchangeService {
    NSDictionary<NSString *, NSString *> *_exchangeRates;
    NetworkingService *_networkingService;
    NSTimer *_updateTimer;
}

- (instancetype) init {
    if (self = [super init]) {
        _exchangeRates = @{@"EUR" : @"1.000", @"USD" : @"1.16", @"GBP" : @"0.81523"};
        _networkingService = [NetworkingService new];
        [self updateExchangeRates:nil];
        _updateTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                        target:self
                                                      selector:@selector(updateExchangeRates:)
                                                      userInfo:nil
                                                       repeats:YES];
    }
    return self;
}

- (void)dealloc {
    [_updateTimer invalidate];
    _updateTimer = nil;
}

- (NSDecimalNumber *)exchangeRateFromCurrency:(NSString *)fromCurrency
                                   toCurrency:(NSString *)toCurrency {
    NSDecimalNumber *fromCurrencyRate = [[NSDecimalNumber alloc] initWithString:_exchangeRates[fromCurrency]];
    NSDecimalNumber *toCurrencyRate = [[NSDecimalNumber alloc] initWithString:_exchangeRates[toCurrency]];
    return [toCurrencyRate decimalNumberByDividingBy:fromCurrencyRate];
}

- (NSDecimalNumber *)calculateExchangeOfAmount:(NSDecimalNumber *)amount
                                    inCurrency:(NSString *)fromCurrency
                                    toCurrency:(NSString *)toCurrency {
    __block BOOL fromCurrencyExist = NO;
    __block BOOL toCurrencyExist = NO;
    [_exchangeRates.allKeys enumerateObjectsUsingBlock:^(NSString *currency, NSUInteger idx, BOOL *stop) {
        if ([fromCurrency isEqualToString:currency]) {
            fromCurrencyExist = YES;
        }
        if ([toCurrency isEqualToString:currency]) {
            toCurrencyExist = YES;
        }
    }];

    NSCAssert(fromCurrencyExist, @"Unsupported FROM currency %@", fromCurrency);
    NSCAssert(toCurrencyExist, @"Unsupported TO currency %@", toCurrency);

    if (!fromCurrencyExist || !toCurrencyExist) {
        return nil;
    }

    if ([fromCurrency isEqualToString:toCurrency]) {
        return amount;
    }

    if (amount == [NSDecimalNumber notANumber]) {
        return [[NSDecimalNumber alloc] initWithString:@"0.0"];
    }

    NSDecimalNumber *euroAmount = nil;
    if ([fromCurrency isEqualToString:@"EUR"]) {
        euroAmount = amount;
    } else {
        euroAmount = [self convertToEurAmount:amount inCurrency:fromCurrency];
    }
    NSDecimalNumber *exchangeRate = [[NSDecimalNumber alloc] initWithString:_exchangeRates[toCurrency]];
    return [euroAmount decimalNumberByMultiplyingBy:exchangeRate];

}

- (NSDecimalNumber *)convertToEurAmount:(NSDecimalNumber *)amount inCurrency:(NSString *)currency {
    NSDecimalNumber *exchangeRate = [[NSDecimalNumber alloc] initWithString:_exchangeRates[currency]];
    return [amount decimalNumberByDividingBy:exchangeRate];
}

- (void)updateExchangeRates:(id)timer {
    __weak typeof(self) wself = self;
    [_networkingService receiveCurrentExchangeRatesCompleted:^(BOOL success, NSDictionary<NSString *, NSString *> *rates, NSError *error) {
        typeof(self) sself = wself;
        if (success) {
            sself->_exchangeRates = [rates copy];
            [sself->_delegate exchangeServiceDidUpdateRates:sself];
        } else {
            //TODO: handle update error
        }
    }];
}



@end