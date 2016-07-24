//
// Created by Филипп Панфилов on 20/07/16.
// Copyright (c) 2016 test. All rights reserved.
//

#import "ExchangeViewController.h"
#import "ExchangeModel.h"
#import "ScrollingBankAccountsView.h"
#import "UIView+EXC.h"
#import "BankAccount.h"
#import "NSString+EXC.h"

@interface ExchangeViewController () <ExchangeModelDelegate, ScrollingBankAccountsViewDelegate>

@end

@implementation ExchangeViewController {
    __weak IBOutlet UIButton *_cancelButton;
    __weak IBOutlet UIButton *_exchangeButton;
    __weak IBOutlet UIView   *_withdrawAccountsViewPlacement;
    __weak IBOutlet UIView   *_depositAccountsViewPlacement;
    __weak IBOutlet UILabel  *_exchangeRateLabel;

    ScrollingBankAccountsView *_withdrawScrollingView;
    ScrollingBankAccountsView *_depositScrollingView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    ScrollingBankAccountsView *withdrawView = [ScrollingBankAccountsView exc_create];
    withdrawView.viewType = BankAccountViewType_Withdraw;
    [withdrawView configureWithBankAccounts:_model.bankAccounts];
    withdrawView.delegate = self;
    _withdrawScrollingView = withdrawView;
    [self placeScrollingBankAccountsView:withdrawView inView:_withdrawAccountsViewPlacement];
    ScrollingBankAccountsView *depositView = [ScrollingBankAccountsView exc_create];
    depositView.viewType = BankAccountViewType_Deposit;
    [depositView configureWithBankAccounts:_model.bankAccounts];
    depositView.delegate = self;
    _depositScrollingView = depositView;
    [self placeScrollingBankAccountsView:depositView inView:_depositAccountsViewPlacement];

    [_exchangeButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_withdrawScrollingView becomeFirstResponder];
}

- (void)setModel:(ExchangeModel *)model {
    _model = model;
    _model.delegate = self;
}

- (IBAction)exchangeButtonPressed:(id)sender {
    [_model exchangeAmount:_withdrawScrollingView.currentAmount
               fromAccount:_withdrawScrollingView.selectedBankAccount
                 toAccount:_depositScrollingView.selectedBankAccount];
}

#pragma mark - ScrollingBankAccountsViewDelegate

- (void)scrollingBankAccountsView:(ScrollingBankAccountsView *)scrollingBankAccountsView
         didChangeCurrentAmountTo:(NSDecimalNumber *)amount
                       inCurrency:(NSString *)currency {
    ScrollingBankAccountsView *viewToUpdate = scrollingBankAccountsView.viewType == BankAccountViewType_Withdraw ? _depositScrollingView : _withdrawScrollingView;
    [viewToUpdate recalculateExchangeAndUpdateViewsForAmount:amount
                                                  inCurrency:currency
                                             exchangeService:_model.exchangeService];
}

- (void)scrollingBankAccountsView:(ScrollingBankAccountsView *)scrollingBankAccountsView
canWithdrawMoneyFromSelectedAccount:(BOOL)canWithdrawMoney {
    _exchangeButton.enabled = canWithdrawMoney;
}

- (void)scrollingBankAccountsViewDidChangeAccount:(ScrollingBankAccountsView *)scrollingBankAccountsView {
    if (scrollingBankAccountsView.viewType == BankAccountViewType_Withdraw) {
        _model.selectedFromCurrency = scrollingBankAccountsView.selectedBankAccount.currencyName;
        [_depositScrollingView updateSmallExchangeRateWithCurrency:_withdrawScrollingView.selectedBankAccount.currencyName
                                                   exchangeService:_model.exchangeService];
    } else {
        _model.selectedToCurrency = scrollingBankAccountsView.selectedBankAccount.currencyName;
    }
    [self updateExchangeLabel];

    _exchangeButton.enabled = _withdrawScrollingView.selectedBankAccountHasEnoughMoney;
}

#pragma mark - ExchangeModelDelegate

- (void)exchangeModel:(ExchangeModel *)model didUpdateExchangeRates:(ExchangeService *)exchangeService {
    [_depositScrollingView recalculateExchangeAndUpdateViewsForAmount:_withdrawScrollingView.currentAmount
                                                           inCurrency:_withdrawScrollingView.selectedBankAccount.currencyName
                                                      exchangeService:_model.exchangeService];
    [_depositScrollingView updateSmallExchangeRateWithCurrency:_withdrawScrollingView.selectedBankAccount.currencyName
                                               exchangeService:_model.exchangeService];
    [self updateExchangeLabel];
}


#pragma mark - Private

- (void)placeScrollingBankAccountsView:(ScrollingBankAccountsView *)scrollingBankAccountsView inView:(UIView *)view {
    [view addSubview:scrollingBankAccountsView];
    scrollingBankAccountsView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                 options:(NSLayoutFormatOptions) 0
                                                                 metrics:nil
                                                                   views:@{@"view":scrollingBankAccountsView}]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                 options:(NSLayoutFormatOptions) 0
                                                                 metrics:nil
                                                                   views:@{@"view":scrollingBankAccountsView}]];
}

- (void)updateExchangeLabel {
    if ([_model.selectedFromCurrency isEqualToString:_model.selectedToCurrency]) {
        _exchangeRateLabel.text = @"=";
    } else {
        _exchangeRateLabel.attributedText = [NSString exc_beautifulExchangeRateStringFromCurrency:_model.selectedFromCurrency
                                                                                       toCurrency:_model.selectedToCurrency
                                                                                           amount:_model.currentExchangeRate];
    }
}


@end