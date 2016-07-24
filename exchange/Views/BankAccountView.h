//
//  BankAccountView.h
//  exchange
//
//  Created by Филипп Панфилов on 20/07/16.
//  Copyright © 2016 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BankAccount;
@protocol BankAccountViewDelegate;

typedef NS_ENUM(NSInteger, BankAccountViewType) {
    BankAccountViewType_Withdraw,
    BankAccountViewType_Deposit
};

@interface BankAccountView : UIView

@property (nonatomic) BankAccountViewType viewType;
@property (nonatomic, weak) id<BankAccountViewDelegate> delegate;
@property (nonatomic, readonly) NSString *currency;
@property (nonatomic, readonly) NSDecimalNumber *amount;
@property (nonatomic, readonly) BOOL enoughMoney;


- (void)configureWithBankAccount:(BankAccount *)bankAccount;
- (void)updateWithNewAmount:(NSDecimalNumber *)newAmount;

- (void)updateWithNewExchangeRate:(NSAttributedString *)exchangeRate;
@end

@protocol BankAccountViewDelegate <NSObject>

- (void)bankAccountView:(BankAccountView *)bankAccountView
      didChangeAmountTo:(NSDecimalNumber *)amount;
- (void)bankAccountViewHasEnoughMoney:(BankAccountView *)bankAccountView;
- (void)bankAccountViewHasNotEnoughMoney:(BankAccountView *)bankAccountView;

@end
