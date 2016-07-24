//
// Created by Филипп Панфилов on 20/07/16.
// Copyright (c) 2016 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (EXC)

@property (nonatomic) IBInspectable UIColor *exc_borderColor;
@property (nonatomic) IBInspectable NSInteger exc_borderWidth;
@property (nonatomic) IBInspectable NSInteger exc_cornerRadius;

+ (instancetype)exc_create;
@end