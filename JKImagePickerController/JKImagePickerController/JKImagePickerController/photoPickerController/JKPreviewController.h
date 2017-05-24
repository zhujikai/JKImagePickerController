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

/**
 现在选中的是第几个图片
 */
@property (assign, nonatomic) NSInteger selectNumber;

/**
 asset数组
 */
@property (strong, nonatomic) NSArray *assets;

/**
 image数组
 */
@property (strong, nonatomic) NSArray <UIImage *>*images;

/**
 URL数组
 */
@property (strong, nonatomic) NSArray <NSString *>*urls;

/**
 相册照片集合
 */
@property (strong, nonatomic) PHFetchResult *result;

/**
 最大可选照片数(内部调用)
 */
@property (assign, nonatomic) int maxSelectCount;

/**
 对图片进行剪切的类型（默认不剪切）（内部调用）
 */
@property (assign, nonatomic) NSInteger cutType;

/**
 返回要裁剪的照片及要裁剪区域的相对位置
 */
@property (copy, nonatomic) void (^returnSelectImage)(PHAsset *, CGRect);


@end
