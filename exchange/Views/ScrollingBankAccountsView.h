//
//  ScrollingBankAccountsView.h
//  exchange
//
//  Created by Филипп Панфилов on 20/07/16.
//  Copyright © 2016 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankAccountView.h"

@class BankAccount;
@protocol ScrollingBankAccountsViewDelegate;
@class ExchangeService;

@interface ScrollingBankAccountsView : UIView

@property (nonatomic) BankAccountViewType viewType;
@property (nonatomic, weak) id<ScrollingBankAccountsViewDelegate> delegate;
@property (nonatomic, readonly) BankAccount *selectedBankAccount;
@property (nonatomic, readonly) NSDecimalNumber *currentAmount;
@property (nonatomic, readonly) BOOL selectedBankAccountHasEnoughMoney;
@property (nonatomic, readonly) BOOL isEditing;

- (void)configureWithBankAccounts:(NSArray<BankAccount *> *)bankAccounts;

- (void)recalculateExchangeAndUpdateViewsForAmount:(NSDecimalNumber *)amount
                                        inCurrency:(NSString *)currency
                                   exchangeService:(ExchangeService *)exchangeService;

- (void)updateSmallExchangeRateWithCurrency:(NSString *)currency exchangeService:(ExchangeService *)service;
@end

@protocol ScrollingBankAccountsViewDelegate <NSObject>

- (void)scrollingBankAccountsView:(ScrollingBankAccountsView *)scrollingBankAccountsView
         didChangeCurrentAmountTo:(NSDecimalNumber *)amount
                       inCurrency:(NSString *)currency;
- (void)scrollingBankAccountsView:(ScrollingBankAccountsView *)scrollingBankAccountsView
canWithdrawMoneyFromSelectedAccount:(BOOL)canWithdrawMoney;

-(void)scrollingBankAccountsViewDidChangeAccount:(ScrollingBankAccountsView *)scrollingBankAccountsView;

@end
