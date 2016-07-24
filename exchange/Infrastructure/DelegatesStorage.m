//
// Created by Филипп Панфилов on 20/07/16.
// Copyright (c) 2016 test. All rights reserved.
//

#import "DelegatesStorage.h"


@implementation DelegatesStorage {
    NSHashTable *_delegates;
}

#pragma mark - Init
- (id)init {
    self = [super init];
    if (self) {
        _delegates = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

#pragma mark - Public
- (void)addDelegate:(id)delegate {
    [_delegates addObject:delegate];
}

- (void)removeDelegate:(id)delegate {
    [_delegates removeObject:delegate];
}

- (void)enumerateDelegatesUsingBlock:(void (^)(id delegate))enumerateBlock
              withRespondentSelector:(SEL)selector {

    id delegate = nil;
    NSEnumerator *enumerator = [[_delegates copy] objectEnumerator];
    while ((delegate = [enumerator nextObject])) {
        if ([delegate respondsToSelector:selector] && enumerateBlock) {
            enumerateBlock(delegate);
        }
    }
}

- (NSArray *)delegatesRespondToSelector:(SEL)selector {
    NSMutableArray *delegates = [@[] mutableCopy];

    [self enumerateDelegatesUsingBlock:^(id delegate) {
        [delegates addObject:delegate];
    } withRespondentSelector:selector];

    return delegates;
}


@end