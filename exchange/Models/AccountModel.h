//
// Created by Филипп Панфилов on 20/07/16.
// Copyright (c) 2016 test. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BankAccount;


@interface AccountModel : NSObject

@property (nonatomic, readonly) NSArray<BankAccount *> *bankAccounts;

@end