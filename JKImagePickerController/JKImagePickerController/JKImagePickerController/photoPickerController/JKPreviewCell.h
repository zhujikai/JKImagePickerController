//
//  JKPreviewCell.h
//  JKImagePickerController
//
//  Created by zjk on 2017/2/13.
//  Copyright © 2017年 zhuJiKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "JKCutImageScaleView.h"
#define PHONE_WIDTH [UIScreen mainScreen].bounds.size.width
#define PHONE_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface JKPreviewCell : UICollectionViewCell<UIScrollViewDelegate>


@property (copy, nonatomic) void (^returnTap)();

@property (copy, nonatomic) void (^returnDidScroll)(BOOL);

@property (assign, nonatomic) BOOL isLayoutFinish;

/**
 是否选择的多个图
 */
@property (assign, nonatomic) BOOL isMultiple;

/**
 对图片进行剪切的类型（默认不剪切）
 */
@property (assign, nonatomic) NSInteger cutType;

@property (strong, nonatomic) UIScrollView *backScrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) JKCutImageScaleView *scaleView;

@property (strong, nonatomic) PHAsset *asset;

@property (strong, nonatomic) UIImage *image;

- (CGRect)selectCutImageFinish;

@end
