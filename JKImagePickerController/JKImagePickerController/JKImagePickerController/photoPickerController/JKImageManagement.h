//
//  JKImageManagement.h
//  JKImagePickerController
//
//  Created by zjk on 2017/2/10.
//  Copyright © 2017年 zhuJiKai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
typedef enum : NSUInteger {
    noRequest, 
    noUse,
    yesUse,
} albumAuthority;

@interface JKImageManagement : NSObject

+ (instancetype)sharedInstance;

@property (strong, nonatomic) PHCachingImageManager *imageManager;

/**
 获取所有相册列表

 @return 相册列表
 */
+ (NSArray *)getAlbums;

/**
 根据相册获取照片集合

 @param assetCollection 相册的对象

 @return 照片集合
 */
+ (PHFetchResult *)getFetchResultWithAssetCollection:(PHAssetCollection *)assetCollection ;

/**
 获取所有照片的集合

 @return 照片集合
 */
+ (PHFetchResult *)getAllPhoto;

/**
 获取所有的视频集合

 @return 视频集合
 */
+ (PHFetchResult *)getAllVideo;

/**
 获取单张照片

 @param asset         <#asset description#>
 @param targetSize    <#targetSize description#>
 @param resultHandler <#resultHandler description#>
 */
+ (void)getPhotoWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize resultHandler:(void(^)(UIImage *result, NSDictionary *info))resultHandler;

/**
 获取单张裁剪后的照片

 @param asset         照片类
 @param targetSize    大小
 @param cutRect       裁剪位置
 @param resultHandler <#resultHandler description#>
 */
+ (void)getPhotoWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize cutRect:(CGRect)cutRect resultHandler:(void(^)(UIImage *result, NSDictionary *info))resultHandler;

+ (void)getImageWithAssets:(NSArray <PHAsset *>*)assets maxSize:(int)maxSize completion:(void (^)(UIImage *photo,NSDictionary *info))completion;

/**
 将英文相册名改为中文

 @param title 英文相册名

 @return 转换后的相册名
 */
+ (NSString *)transformAblumTitle:(NSString *)title;

/**
 判断是否能够使用相册

 @return 状态
 */
+ (albumAuthority)isCanUsePhotos;

/**
 请求使用相册

 @param Status <#Status description#>
 */
+ (void)usePhotos:(void(^)(BOOL status))Status;

@end
