//
// Created by Филипп Панфилов on 20/07/16.
// Copyright (c) 2016 test. All rights reserved.
//

#import "BankAccount.h"
#import "DelegatesStorage.h"

@implementation BankAccount {
    DelegatesStorage *_delegatesStorage;
}

- (instancetype)initWithCurrencyName:(NSString *)currencyName currencyAmount:(NSDecimalNumber *)currencyAmount {
    self = [super init];
    if (self) {
        _currencyName = currencyName;
        _currencyAmount = currencyAmount;
        _delegatesStorage = [DelegatesStorage new];
    }

    return self;
}

+ (instancetype)accountWithCurrencyName:(NSString *)currencyName currencyAmount:(NSDecimalNumber *)currencyAmount {
    return [[self alloc] initWithCurrencyName:currencyName currencyAmount:currencyAmount];
}

#pragma mark - Public

- (void)addDelegate:(id<BankAccountDelegate>)delegate {
    [_delegatesStorage addDelegate:delegate];
}

- (void)withdrawAmount:(NSDecimalNumber *)amount {
    NSCAssert(([_currencyAmount decimalNumberBySubtracting:amount]).doubleValue >= 0, @"Incorrect withdraw amount: operation will cause negative result");
    if (([_currencyAmount decimalNumberBySubtracting:amount]).doubleValue < 0) {
        return;
    }

    _currencyAmount = [_currencyAmount decimalNumberBySubtracting:amount];
    [self notifyDelegatesIfAmountChanged];
}

- (void)depositAmount:(NSDecimalNumber *)amount {
    _currencyAmount = [_currencyAmount decimalNumberByAdding:amount];
    [self notifyDelegatesIfAmountChanged];
}

#pragma mark - Private
- (void)notifyDelegatesIfAmountChanged {
    [_delegatesStorage enumerateDelegatesUsingBlock:^(id<BankAccountDelegate> delegate) {
        [delegate bankAccountAmountDidChange:self];
    } withRespondentSelector:@selector(bankAccountAmountDidChange:)];
}

@end