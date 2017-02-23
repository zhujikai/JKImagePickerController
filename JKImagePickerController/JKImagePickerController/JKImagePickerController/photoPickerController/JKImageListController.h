//
//  JKImageListController.h
//  JKImagePickerController
//
//  Created by zjk on 2017/2/10.
//  Copyright © 2017年 zhuJiKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface JKImageListController : UIViewController

@property (assign, nonatomic) int maxSelectCount;

/**
 对图片进行剪切的类型（默认不剪切）
 */
@property (assign, nonatomic) NSInteger cutType;

@property (copy, nonatomic) void (^returnSelectImageAsset)(NSArray<PHAsset *>*);
@property (copy, nonatomic) void (^returnSelectImage)(PHAsset *, CGRect);

@end
