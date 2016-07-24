//
// Created by Филипп Панфилов on 21/07/16.
// Copyright (c) 2016 test. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ExchangeServiceDelegate;

@interface ExchangeService : NSObject

@property (nonatomic, weak) id<ExchangeServiceDelegate> delegate;

- (NSDecimalNumber *)exchangeRateFromCurrency:(NSString *)fromCurrency toCurrency:(NSString *)toCurrency;

- (NSDecimalNumber *)calculateExchangeOfAmount:(NSDecimalNumber *)amount
                                    inCurrency:(NSString *)fromCurrency
                                    toCurrency:(NSString *)toCurrency;

@end

@protocol ExchangeServiceDelegate <NSObject>

- (void)exchangeServiceDidUpdateRates:(ExchangeService *)service;

@end