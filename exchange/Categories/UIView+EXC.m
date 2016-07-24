//
// Created by Филипп Панфилов on 20/07/16.
// Copyright (c) 2016 test. All rights reserved.
//

#import "UIView+EXC.h"


@implementation UIView (EXC)

@dynamic exc_borderColor, exc_borderWidth, exc_cornerRadius;

- (void)setExc_borderColor:(UIColor *)borderColor {
    [self.layer setBorderColor:borderColor.CGColor];
}

- (void)setExc_borderWidth:(NSInteger)borderWidth {
    [self.layer setBorderWidth:borderWidth];
}

- (void)setExc_cornerRadius:(NSInteger)cornerRadius {
    [self.layer setCornerRadius:cornerRadius];
}

+ (instancetype)exc_create {
    NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    UIView *loadedView = nil;
    if ([xibs count] > 0)  {
        NSCAssert([xibs count] == 1, @"Invalid number of xibs inside BankAccountView");
        loadedView = [xibs firstObject];
    }
    return loadedView;
}

@end