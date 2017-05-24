//
//  JKPreviewVideoController.h
//  JKImagePickerController
//
//  Created by zjk on 2017/3/10.
//  Copyright © 2017年 zhuJiKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKImageManagement.h"

#define PHONE_WIDTH [UIScreen mainScreen].bounds.size.width
#define PHONE_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface JKPreviewVideoController : UIViewController

@property (copy, nonatomic) void (^returnVideoUrl)(NSURL *);

@property (strong, nonatomic) PHAsset *asset;

@property (strong, nonatomic) NSURL *videoUrl;

@end
