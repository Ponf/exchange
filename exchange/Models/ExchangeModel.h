//
// Created by Филипп Панфилов on 20/07/16.
// Copyright (c) 2016 test. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ExchangeModelDelegate;
@class AccountModel;
@class BankAccount;
@class ExchangeService;


@interface ExchangeModel : NSObject

@property (nonatomic) ExchangeService *exchangeService;
@property (nonatomic, weak) id<ExchangeModelDelegate> delegate;
@property (nonatomic, readonly) NSArray<BankAccount *> *bankAccounts;
@property (nonatomic, readonly) NSDecimalNumber *currentExchangeRate;
@property (nonatomic) NSString *selectedFromCurrency;
@property (nonatomic) NSString *selectedToCurrency;

- (instancetype)initWithAccountModel:(AccountModel *)account;

- (void)exchangeAmount:(NSDecimalNumber *)amount fromAccount:(BankAccount *)fromAccount toAccount:(BankAccount *)toAccount;
@end

@protocol ExchangeModelDelegate <NSObject>

- (void)exchangeModel:(ExchangeModel *)model didUpdateExchangeRates:(ExchangeService *)exchangeService;

@end