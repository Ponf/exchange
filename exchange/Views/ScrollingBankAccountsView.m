//
//  ScrollingBankAccountsView.m
//  exchange
//
//  Created by Филипп Панфилов on 20/07/16.
//  Copyright © 2016 test. All rights reserved.
//

#import "ScrollingBankAccountsView.h"
#import "BankAccount.h"
#import "UIView+EXC.h"
#import "ExchangeService.h"
#import "NSString+EXC.h"

@interface ScrollingBankAccountsView () <UIScrollViewDelegate, BankAccountViewDelegate>

@end

@implementation ScrollingBankAccountsView {
    __weak IBOutlet UIScrollView *_scrollView;
    __weak IBOutlet UIPageControl *_pageControl;
    NSArray<BankAccount *> *_bankAccounts;
    NSArray<BankAccountView *> *_bankAccountViews;
}

- (void)configureWithBankAccounts:(NSArray<BankAccount *> *)bankAccounts {
    _bankAccounts = bankAccounts;
    [self prepareBankAccountViews];

    UIPageControl *pageControl = _pageControl;
    pageControl.numberOfPages = bankAccounts.count;
    pageControl.currentPage = 0;
    [self layoutBankAccountViews];
}

- (void)recalculateExchangeAndUpdateViewsForAmount:(NSDecimalNumber *)amount
                                        inCurrency:(NSString *)currency
                                   exchangeService:(ExchangeService *)exchangeService {
    [_bankAccountViews enumerateObjectsUsingBlock:^(BankAccountView *accountView, NSUInteger idx, BOOL *stop) {
        NSDecimalNumber *newAmount = [exchangeService calculateExchangeOfAmount:amount
                                                                     inCurrency:currency
                                                                     toCurrency:accountView.currency];
        [accountView updateWithNewAmount:newAmount];
    }];
}

- (void)updateSmallExchangeRateWithCurrency:(NSString *)currency exchangeService:(ExchangeService *)service {
    [_bankAccountViews enumerateObjectsUsingBlock:^(BankAccountView *accountView, NSUInteger idx, BOOL *stop) {
        NSDecimalNumber *exchangeRate = [service exchangeRateFromCurrency:accountView.currency toCurrency:currency];
        NSAttributedString *exchangeString = [NSString exc_shortBeautifulExchangeStringFromCurrency:accountView.currency
                                                                                         toCurrency:currency
                                                                                             amount:exchangeRate];
        [accountView updateWithNewExchangeRate:exchangeString];
    }];

}

- (BankAccount *)selectedBankAccount {
    return _bankAccounts[(NSUInteger) _pageControl.currentPage];
}

- (NSDecimalNumber *)currentAmount {
    return  [self currentBankAccountView].amount;
}

- (BOOL)selectedBankAccountHasEnoughMoney {
    return [self currentBankAccountView].enoughMoney;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutBankAccountViews];
}

- (BOOL)becomeFirstResponder {
    _scrollView.scrollEnabled = NO;
    [[self currentBankAccountView] becomeFirstResponder];
    _scrollView.scrollEnabled = YES;
    return [super becomeFirstResponder];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSInteger page = (NSInteger) (targetContentOffset->x / _scrollView.frame.size.width) - 1;
    if (page < 0) {
        page = _bankAccounts.count - 1;
    } else if (page > (_bankAccounts.count - 1)) {
        page = 0;
    }
    [_pageControl setCurrentPage:page];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x < _scrollView.frame.size.width) {
        scrollView.contentOffset = CGPointMake((_pageControl.currentPage + 1) * scrollView.frame.size.width, 0);
    } else if (scrollView.contentOffset.x > ((_pageControl.currentPage + 1) * scrollView.frame.size.width)) {
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
    }
    [_delegate scrollingBankAccountsViewDidChangeAccount:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!scrollView.isDragging && !scrollView.isDecelerating) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, -scrollView.contentInset.top) animated:NO];
    }
}

#pragma mark - BankAccountViewDelegate
- (void)bankAccountView:(BankAccountView *)bankAccountView
      didChangeAmountTo:(NSDecimalNumber *)amount {
    [_delegate scrollingBankAccountsView:self
                didChangeCurrentAmountTo:amount
                              inCurrency:bankAccountView.currency];
}

- (void)bankAccountViewHasEnoughMoney:(BankAccountView *)bankAccountView {
    if (bankAccountView == [self currentBankAccountView]) {
        [_delegate scrollingBankAccountsView:self
         canWithdrawMoneyFromSelectedAccount:YES];
    }
}

- (void)bankAccountViewHasNotEnoughMoney:(BankAccountView *)bankAccountView {
    if (bankAccountView == [self currentBankAccountView]) {
        [_delegate scrollingBankAccountsView:self
         canWithdrawMoneyFromSelectedAccount:NO];
    }
}


#pragma mark - Private
- (void)prepareBankAccountViews {
    NSMutableArray *tempBankViews = @[].mutableCopy;

    //creating fake first bank account view
    BankAccountView *lastAccountView = [BankAccountView exc_create];
    [lastAccountView configureWithBankAccount:[_bankAccounts lastObject]];
    lastAccountView.viewType = _viewType;
    lastAccountView.delegate = self;
    [tempBankViews addObject:lastAccountView];

    [_bankAccounts enumerateObjectsUsingBlock:^(BankAccount *account, NSUInteger idx, BOOL *stop) {
        BankAccountView *accountView = [BankAccountView exc_create];
        accountView.viewType = _viewType;
        [accountView configureWithBankAccount:account];
        accountView.delegate = self;
        [tempBankViews addObject:accountView];
    }];

    //creating fake last bank account view
    BankAccountView *firstAccountView = [BankAccountView exc_create];
    [firstAccountView configureWithBankAccount:[_bankAccounts firstObject]];
    firstAccountView.viewType = _viewType;
    firstAccountView.delegate = self;
    [tempBankViews addObject:firstAccountView];

    _bankAccountViews = tempBankViews.copy;
}

- (void)layoutBankAccountViews {
    UIScrollView *scrollView = _scrollView;
    scrollView.contentSize = scrollView.frame.size;
    [_bankAccountViews enumerateObjectsUsingBlock:^(BankAccountView *accountView, NSUInteger idx, BOOL *stop) {
        CGRect rect = scrollView.frame;
        CGRect frame = CGRectMake(rect.size.width * idx, 0, rect.size.width, rect.size.height);
        accountView.frame = frame;
        [scrollView addSubview:accountView];
    }];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [_bankAccountViews count], scrollView.frame.size.height);
    scrollView.contentOffset = CGPointMake((_pageControl.currentPage + 1) * scrollView.frame.size.width, 0);
}

- (BankAccountView *)currentBankAccountView {
    return _bankAccountViews[(NSUInteger) _pageControl.currentPage + 1];
}

@end
