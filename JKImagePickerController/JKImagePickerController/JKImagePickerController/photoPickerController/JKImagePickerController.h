//
//  JKImagePickerController.h
//  JKImagePickerController
//
//  Created by zjk on 2017/2/10.
//  Copyright © 2017年 zhuJiKai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    cutImageNone,
    cutImageSquare,
    cutImageRound,
} cutImageType;

@protocol JKImagePickerControllerDelegate;
@interface JKImagePickerController : UINavigationController

@property (assign, nonatomic) id<JKImagePickerControllerDelegate> JKDelegate;

/**
 所需要图片的最大宽高(返回的图片会稍微大于此size)
 */
@property (assign, nonatomic) int imageMaxSize;

/**
 可选择图片的最大数量（最大9）
 */
@property (assign, nonatomic) int selectMaxCount;

/**
 对图片进行剪切的类型（默认不剪切）
 */
@property (assign, nonatomic) cutImageType cutType;

@end

@protocol JKImagePickerControllerDelegate <NSObject>


/**
 选择图片完成的回调

 @param picker                控制器（暂时没有用处）
 @param photos                图片集合
 @param assets                assets集合
 @param isSelectOriginalPhoto 是否选择原图
 */
- (void)imagePickerController:(JKImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto;

/**
 返回单张图片（获取头像，如选择了对图片进行剪切，则返回剪切后的图片）

 @param picker 控制器（暂时没有用处）
 @param image  返回的图片
 */
- (void)imagePickerController:(JKImagePickerController *)picker didFinishCutImage:(UIImage *)image;

@end
