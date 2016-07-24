//
// Created by Филипп Панфилов on 20/07/16.
// Copyright (c) 2016 test. All rights reserved.
//

#import "ExchangeModel.h"
#import "AccountModel.h"
#import "BankAccount.h"
#import "ExchangeService.h"


@interface ExchangeModel () <ExchangeServiceDelegate>
@end

@implementation ExchangeModel {
    AccountModel *_account;
}

- (instancetype)initWithAccountModel:(AccountModel *)account {
    if (self = [super init]) {
        _account = account;
    }
    _selectedToCurrency = _selectedFromCurrency = @"USD";
    return self;
}

- (void)setExchangeService:(ExchangeService *)exchangeService {
    _exchangeService = exchangeService;
    exchangeService.delegate = self;
}

- (NSArray<BankAccount *> *)bankAccounts {
    return _account.bankAccounts;
}

- (NSDecimalNumber *)currentExchangeRate {
    return [_exchangeService exchangeRateFromCurrency:_selectedFromCurrency toCurrency:_selectedToCurrency];
}

- (void)exchangeAmount:(NSDecimalNumber *)amount
           fromAccount:(BankAccount *)fromAccount
             toAccount:(BankAccount *)toAccount {
    NSDecimalNumber *amountToDeposit = [_exchangeService calculateExchangeOfAmount:amount
                                                                        inCurrency:_selectedFromCurrency
                                                                        toCurrency:_selectedToCurrency];
    [fromAccount withdrawAmount:amount];
    [toAccount depositAmount:amountToDeposit];

}

#pragma mark - ExchangeServiceDelegate
- (void)exchangeServiceDidUpdateRates:(ExchangeService *)service {
    [_delegate exchangeModel:self didUpdateExchangeRates:service];
}

@end