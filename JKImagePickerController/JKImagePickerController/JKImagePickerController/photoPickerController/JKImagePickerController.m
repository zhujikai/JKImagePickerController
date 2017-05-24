//
//  JKImagePickerController.m
//  JKImagePickerController
//
//  Created by zjk on 2017/2/10.
//  Copyright © 2017年 zhuJiKai. All rights reserved.
//

#import "JKImagePickerController.h"
#import "JKImageListController.h"
#import "JKImageManagement.h"
#import "JKVideoCollectionController.h"

@interface JKImagePickerController ()

@end

@implementation JKImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isVideo) {
        [self configPushVideo];
    } else {
        [self configPush];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_JKDelegate && [_JKDelegate respondsToSelector:@selector(imagePickerControllerDismiss)]) {
        [_JKDelegate imagePickerControllerDismiss];
    }
}

- (void)configPush {
    __weak typeof(self) weakSelf = self;
    JKImageListController *imageList = [[JKImageListController alloc] init];
    imageList.maxSelectCount = self.selectMaxCount?self.selectMaxCount:9;
    imageList.cutType = self.cutType;
    imageList.returnSelectImageAsset = ^(NSArray<PHAsset *>* assetArr) {
        NSMutableArray *imageArr = [NSMutableArray array];
        [assetArr enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [JKImageManagement getPhotoWithAsset:obj targetSize:weakSelf.imageMaxSize?CGSizeMake(weakSelf.imageMaxSize, weakSelf.imageMaxSize):CGSizeMake(600, 600) resultHandler:^(UIImage *result, NSDictionary *info) {
                if (![info[PHImageResultIsDegradedKey] boolValue]) {
                    [imageArr addObject:result];
                }
                if (imageArr.count == assetArr.count) {
                    if (_JKDelegate && [_JKDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:)]) {
                        [_JKDelegate imagePickerController:weakSelf didFinishPickingPhotos:imageArr sourceAssets:assetArr isSelectOriginalPhoto:NO];
                    }
                }
            }];
        }];
    };
    imageList.returnSelectImage = ^(PHAsset *asset,CGRect rect) {
        if (rect.size.height == 0) {
            NSMutableArray *imageArr = [NSMutableArray array];
            [JKImageManagement getPhotoWithAsset:asset targetSize:weakSelf.imageMaxSize?CGSizeMake(weakSelf.imageMaxSize, weakSelf.imageMaxSize):CGSizeMake(600, 600) resultHandler:^(UIImage *result, NSDictionary *info) {
                if (![info[PHImageResultIsDegradedKey] boolValue]) {
                    [imageArr addObject:result];
                }
                if (imageArr.count) {
                    if (_JKDelegate && [_JKDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:)]) {
                        [_JKDelegate imagePickerController:weakSelf didFinishPickingPhotos:imageArr sourceAssets:@[asset] isSelectOriginalPhoto:NO];
                    }
                }
                
            }];
        } else {
            [JKImageManagement getPhotoWithAsset:asset targetSize:weakSelf.imageMaxSize?CGSizeMake(weakSelf.imageMaxSize, weakSelf.imageMaxSize):CGSizeMake(400, 400) cutRect:rect resultHandler:^(UIImage *result, NSDictionary *info) {
                if (_JKDelegate && [_JKDelegate respondsToSelector:@selector(imagePickerController:didFinishCutImage:cutType:)]) {
                    [_JKDelegate imagePickerController:weakSelf didFinishCutImage:result cutType:weakSelf.cutType];
                }
            }];
        }
    };
    [self pushViewController:imageList animated:NO];
}

- (void)configPushVideo {
    JKVideoCollectionController *videoList = [[JKVideoCollectionController alloc] init];
    __weak typeof(self) weakSelf = self;
    videoList.returnVideoUrl = ^(NSURL *url) {
        if (_JKDelegate && [_JKDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingVideoUrl:)]) {
            [_JKDelegate imagePickerController:weakSelf didFinishPickingVideoUrl:url];
        }
    };
    [self pushViewController:videoList animated:NO];
}

- (void)dealloc {
    
}

@end
