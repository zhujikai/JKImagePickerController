//
//  JKImageManagement.m
//  JKImagePickerController
//
//  Created by zjk on 2017/2/10.
//  Copyright © 2017年 zhuJiKai. All rights reserved.
//

#import "JKImageManagement.h"

@implementation JKImageManagement

+ (NSArray *)getAlbums {
    // 列出所有相册智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    NSMutableArray *array = [NSMutableArray array];
    [smartAlbums enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHCollection *collection = obj;
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
//            // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
//            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            
            [array addObject:assetCollection];
            
        } else {
            NSAssert(NO, @"Fetch collection not PHCollection: %@", collection);
        }
    }];
    
    // 列出所有用户创建的相册
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    [topLevelUserCollections enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHCollection *collection = obj;
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
//            // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
//            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            
            [array addObject:assetCollection];
            
        } else {
            NSAssert(NO, @"Fetch collection not PHCollection: %@", collection);
        }
    }];
    return array;
}

+ (PHFetchResult *)getFetchResultWithAssetCollection:(PHAssetCollection *)assetCollection {
    // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    return fetchResult;
}

+ (PHFetchResult *)getAllPhoto {
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    if (smartAlbums.count) {
        PHCollection *collection = smartAlbums[0];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            return fetchResult;
            
        } else {
            NSAssert(NO, @"Fetch collection not PHCollection: %@", collection);
        }
    }
    return nil;
}

+ (void)getPhotoWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize resultHandler:(void(^)(UIImage *result, NSDictionary *info))resultHandler {
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    [imageManager requestImageForAsset:asset
                            targetSize:targetSize
                           contentMode:PHImageContentModeAspectFill
                               options:options
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             // 得到一张 UIImage，展示到界面上
                             if (resultHandler) {
                                 resultHandler(result,info);
                             }
                         }];
}

+ (void)getPhotoWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize cutRect:(CGRect)cutRect resultHandler:(void(^)(UIImage *result, NSDictionary *info))resultHandler {
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    options.normalizedCropRect = cutRect;
    
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    [imageManager requestImageForAsset:asset
                            targetSize:targetSize
                           contentMode:PHImageContentModeAspectFit
                               options:options
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             // 得到一张 UIImage，展示到界面上
                             if (![info[@"PHImageResultIsDegradedKey"] boolValue]) {
                                 if (resultHandler) {
                                     resultHandler(result,info);
                                 }
                             }
                         }];
}

+ (NSString *)transformAblumTitle:(NSString *)title
{
    if ([title isEqualToString:@"Slo-mo"]) {
        return @"慢动作";
    } else if ([title isEqualToString:@"Recently Added"]) {
        return @"最近添加";
    } else if ([title isEqualToString:@"Favorites"]) {
        return @"个人收藏";
    } else if ([title isEqualToString:@"Recently Deleted"]) {
//        return @"最近删除";
        return nil;
    } else if ([title isEqualToString:@"Videos"]) {
        return @"视频";
    } else if ([title isEqualToString:@"All Photos"]) {
        return @"所有照片";
    } else if ([title isEqualToString:@"Selfies"]) {
        return @"自拍";
    } else if ([title isEqualToString:@"Screenshots"]) {
        return @"屏幕快照";
    } else if ([title isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    } else if ([title isEqualToString:@"Time-lapse"]) {
        return @"延时摄影";
    } else if ([title isEqualToString:@"Panoramas"]) {
        return @"全景照片";
    } else if ([title isEqualToString:@"Bursts"]) {
        return @"连拍快照";
    } else if ([title isEqualToString:@"Hidden"]) {
        return nil;
    }
    return title;
}

- (void)getImageWithAssets:(NSArray <PHAsset *>*)assets maxSize:(int)maxSize completion:(void (^)(UIImage *photo,NSDictionary *info))completion {
    NSMutableArray *imageArr = [NSMutableArray array];
    // 在资源的集合中获取第一个集合，并获取其中的图片
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = obj;
        [imageManager requestImageForAsset:asset
                                targetSize:maxSize?CGSizeMake(maxSize, maxSize):PHImageManagerMaximumSize
                               contentMode:PHImageContentModeAspectFill
                                   options:options
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 // 得到一张 UIImage，展示到界面上
                                 
                             }];
    }];
}

+ (albumAuthority)isCanUsePhotos {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        //无权限
        return noUse;
    } else if (status == PHAuthorizationStatusNotDetermined) {
        return noRequest;
    }
    return yesUse;
}

+ (void)UsePhotos:(void(^)(BOOL status))Status {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined) {
            
            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
            
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                
                if (Status) {
                    Status(YES);
                }
                
                if (*stop) {
                    
                    // TODO:...
                    return;
                }
                *stop = TRUE;//不能省略
                
            } failureBlock:^(NSError *error) {
                if (Status) {
                    Status(NO);
                }
                NSLog(@"failureBlock");
            }];
        }
    } else {
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
            
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                if (status == PHAuthorizationStatusAuthorized) {
                    if (Status) {
                        Status(YES);
                    }
                    // TODO:...
                } else {
                    if (Status) {
                        Status(NO);
                    }
                }
            }];
        }
    }
}

@end
