//
//  JKCutImageScaleView.h
//  JKImagePickerController
//
//  Created by zjk on 2017/2/20.
//  Copyright © 2017年 zhuJiKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PHONE_WIDTH [UIScreen mainScreen].bounds.size.width
#define PHONE_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface JKCutImageScaleView : UIView

@property (assign, nonatomic) NSInteger cutType;

@end
