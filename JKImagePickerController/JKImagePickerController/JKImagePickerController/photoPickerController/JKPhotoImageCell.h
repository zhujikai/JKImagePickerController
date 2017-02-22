//
//  JKPhotoImageCell.h
//  JKImagePickerController
//
//  Created by zjk on 2017/2/10.
//  Copyright © 2017年 zhuJiKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#define CELL_WIDTH (([UIScreen mainScreen].bounds.size.width - 10) / 4)

@interface JKPhotoImageCell : UICollectionViewCell

/**
 选择图片的回调
 */
@property (copy, nonatomic) BOOL (^returnSelect)(BOOL);

/**
 是否选择的多个图
 */
@property (assign, nonatomic) BOOL isMultiple;

@property (assign, nonatomic) BOOL isLayout;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *videoImageView;
@property (strong, nonatomic) UILabel *videoTimeLab;
@property (strong, nonatomic) UIButton *selectBtn;

@property (strong, nonatomic) PHAsset *asset;

@end
