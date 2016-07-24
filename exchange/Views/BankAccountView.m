//
//  BankAccountView.m
//  exchange
//
//  Created by Филипп Панфилов on 20/07/16.
//  Copyright © 2016 test. All rights reserved.
//

#import "BankAccountView.h"
#import "BankAccount.h"
#import "NSString+EXC.h"
#import "NSDecimalNumber+EXC.h"

@interface BankAccountView () <UITextFieldDelegate, BankAccountDelegate>

@end

@implementation BankAccountView {
    __weak IBOutlet UILabel *_currencyLabel;
    __weak IBOutlet UILabel *_currentAmountLabel;
    __weak IBOutlet UILabel *_exchangeRateLabel;
    __weak IBOutlet UITextField *_exchangeAmountField;

    BankAccount *_bankAccount;
}

#pragma mark - Override

- (BOOL)becomeFirstResponder {
//    [super becomeFirstResponder];
    return [_exchangeAmountField becomeFirstResponder];
}

#pragma mark - Public

- (NSDecimalNumber *)amount {
    return [[NSDecimalNumber alloc] initWithString:[_exchangeAmountField.text substringFromIndex:1]];
}

- (NSString *)currency {
    return _bankAccount.currencyName;
}

- (void)configureWithBankAccount:(BankAccount *)bankAccount {
    _bankAccount = bankAccount;
    _currencyLabel.text = bankAccount.currencyName;
    [self updateCurrentAmountLabel];
    [bankAccount addDelegate:self];
}

- (void)setViewType:(BankAccountViewType)viewType {
    _viewType = viewType;
    _exchangeRateLabel.hidden = _viewType == BankAccountViewType_Withdraw;
    _exchangeAmountField.text = _viewType == BankAccountViewType_Withdraw ? @"-0" : @"+0";
}

- (void)updateWithNewAmount:(NSDecimalNumber *)newAmount {
    NSString *prefix = _viewType == BankAccountViewType_Deposit ? @"+" : @"-";
    NSString *newAmountString = [prefix stringByAppendingString:[newAmount stringValue]];
    NSAttributedString *attributedString = [newAmountString exc_beautifulAmountString];

    NSString *separatorString = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];
    NSRange separatorPosition = [_exchangeAmountField.text rangeOfString:separatorString];
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    if (separatorPosition.location == _exchangeAmountField.text.length - 1) {
        [mutableAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:separatorString]];
    }

    _exchangeAmountField.attributedText = mutableAttributedString.copy;
    [self checkIfEnoughMoneyToWithdrawAmount:newAmount];
}

- (void)updateWithNewExchangeRate:(NSAttributedString *)exchangeRate {
    _exchangeRateLabel.attributedText = exchangeRate;
}

#pragma mark - BankAccountDelegate
- (void)bankAccountAmountDidChange:(BankAccount *)bankAccount {
    [self updateCurrentAmountLabel];
    NSDecimalNumber *newAmount = [NSDecimalNumber decimalNumberWithString:[_exchangeAmountField.text substringFromIndex:1]];
    [self checkIfEnoughMoneyToWithdrawAmount:newAmount];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    NSString *separatorString = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];
    if ([string isEqualToString:separatorString] && [_exchangeAmountField.text rangeOfString:separatorString].location != NSNotFound) {
        return NO;
    }

    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    textField.attributedText = [resultString exc_beautifulAmountString];
    NSDecimalNumber *newAmount = [NSDecimalNumber decimalNumberWithString:[textField.text substringFromIndex:1]];
    [self updateWithNewAmount:newAmount];
    [_delegate bankAccountView:self didChangeAmountTo:newAmount];
    return NO;
}


#pragma mark - Private

- (void)updateCurrentAmountLabel {
    _currentAmountLabel.text = [NSString stringWithFormat:@"You have %@", [_bankAccount.currencyAmount exc_stringValueWithCurrencyCode:_bankAccount.currencyName]];
}

- (void)checkIfEnoughMoneyToWithdrawAmount:(NSDecimalNumber *)newAmount {
    if (_viewType == BankAccountViewType_Withdraw) {
        _enoughMoney = [_bankAccount.currencyAmount decimalNumberBySubtracting:newAmount].doubleValue >= 0;
        _currentAmountLabel.textColor = _enoughMoney ? [UIColor whiteColor] : [UIColor redColor];
        if (_enoughMoney) {
            [_delegate bankAccountViewHasEnoughMoney:self];
        } else {
            [_delegate bankAccountViewHasNotEnoughMoney:self];
        }
    }
}

@end
