//
// Created by Филипп Панфилов on 24/07/16.
// Copyright (c) 2016 test. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetworkingService : NSObject

- (void)receiveCurrentExchangeRatesCompleted:(void (^)(BOOL, NSDictionary<NSString *,NSString *> *, NSError *))completed;

@end