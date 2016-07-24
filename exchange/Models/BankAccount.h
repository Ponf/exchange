//
// Created by Филипп Панфилов on 20/07/16.
// Copyright (c) 2016 test. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BankAccountDelegate;


@interface BankAccount : NSObject

@property (nonatomic, readonly) NSString *currencyName;
@property (nonatomic, readonly) NSDecimalNumber *currencyAmount;

- (instancetype)initWithCurrencyName:(NSString *)currencyName currencyAmount:(NSDecimalNumber *)currencyAmount;
+ (instancetype)accountWithCurrencyName:(NSString *)currencyName currencyAmount:(NSDecimalNumber *)currencyAmount;

- (void)addDelegate:(id <BankAccountDelegate>)delegate;

- (void)withdrawAmount:(NSDecimalNumber *)amount;

- (void)depositAmount:(NSDecimalNumber *)amount;
@end

@protocol BankAccountDelegate <NSObject>

- (void)bankAccountAmountDidChange:(BankAccount *)account;

@end