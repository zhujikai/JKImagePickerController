//
//  JKCutImageScaleView.m
//  JKImagePickerController
//
//  Created by zjk on 2017/2/20.
//  Copyright © 2017年 zhuJiKai. All rights reserved.
//

#import "JKCutImageScaleView.h"

@implementation JKCutImageScaleView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)configView {
    self.userInteractionEnabled = NO;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, (PHONE_HEIGHT - PHONE_WIDTH) / 2)];
    topView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self addSubview:topView];
    
    
    UIView *bottonView = [[UIView alloc] initWithFrame:CGRectMake(0, PHONE_HEIGHT - ((PHONE_HEIGHT - PHONE_WIDTH) / 2), PHONE_WIDTH, (PHONE_HEIGHT - PHONE_WIDTH) / 2)];
    bottonView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self addSubview:bottonView];
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, (PHONE_HEIGHT - PHONE_WIDTH) / 2, PHONE_WIDTH, 1)];
    topLine.backgroundColor = [UIColor colorWithRed:0.3 green:0.5 blue:0.1 alpha:1];
    [self addSubview:topLine];
    
    UIView *bottonLine = [[UIView alloc] initWithFrame:CGRectMake(0, PHONE_HEIGHT - ((PHONE_HEIGHT - PHONE_WIDTH) / 2) - 1, PHONE_WIDTH, 1)];
    bottonLine.backgroundColor = [UIColor colorWithRed:0.3 green:0.5 blue:0.1 alpha:1];
    [self addSubview:bottonLine];
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, (PHONE_HEIGHT - PHONE_WIDTH) / 2, 1, PHONE_WIDTH)];
    leftLine.backgroundColor = [UIColor colorWithRed:0.3 green:0.5 blue:0.1 alpha:1];
    [self addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(PHONE_WIDTH - 1, (PHONE_HEIGHT - PHONE_WIDTH) / 2, 1, PHONE_WIDTH)];
    rightLine.backgroundColor = [UIColor colorWithRed:0.3 green:0.5 blue:0.1 alpha:1];
    [self addSubview:rightLine];
    
}

@end
