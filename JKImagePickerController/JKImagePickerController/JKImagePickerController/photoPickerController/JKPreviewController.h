//
//  JKPreviewController.h
//  JKImagePickerController
//
//  Created by zjk on 2017/2/13.
//  Copyright © 2017年 zhuJiKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#define PHONE_WIDTH [UIScreen mainScreen].bounds.size.width
#define PHONE_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface JKPreviewController : UIViewController

@property (assign, nonatomic) NSInteger selectNumber;

@property (strong, nonatomic) NSArray *assets;

@property (strong, nonatomic) PHFetchResult *result;

@property (assign, nonatomic) int maxSelectCount;

@property (copy, nonatomic) void (^returnSelectImage)(PHAsset *, CGRect);

@end
