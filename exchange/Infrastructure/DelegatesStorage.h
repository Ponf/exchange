//
// Created by Филипп Панфилов on 20/07/16.
// Copyright (c) 2016 test. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DelegatesStorage : NSObject
- (void)addDelegate:(id)delegate;

- (void)removeDelegate:(id)delegate;

- (void)enumerateDelegatesUsingBlock:(void (^)(id delegate))enumerateBlock withRespondentSelector:(SEL)selector;

- (NSArray *)delegatesRespondToSelector:(SEL)selector;
@end