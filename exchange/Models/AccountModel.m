//
// Created by Филипп Панфилов on 20/07/16.
// Copyright (c) 2016 test. All rights reserved.
//

#import "AccountModel.h"
#import "BankAccount.h"


@implementation AccountModel {

}

- (instancetype)init {
    if (self = [super init]) {
        _bankAccounts = @[[BankAccount accountWithCurrencyName:@"USD" currencyAmount:[[NSDecimalNumber alloc] initWithString:@"100.0"]],
                [BankAccount accountWithCurrencyName:@"EUR" currencyAmount:[[NSDecimalNumber alloc] initWithString:@"100.0"]],
                [BankAccount accountWithCurrencyName:@"GBP" currencyAmount:[[NSDecimalNumber alloc] initWithString:@"100.0"]]];
    }
    return self;
}
@end