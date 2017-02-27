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

@interface JKImagePickerController ()

@end

@implementation JKImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configPush];
}

- (void)configPush {
    JKImageListController *imageList = [[JKImageListController alloc] init];
    imageList.maxSelectCount = self.selectMaxCount?self.selectMaxCount:1;
    imageList.cutType = self.cutType;
    imageList.returnSelectImageAsset = ^(NSArray<PHAsset *>* assetArr) {
        NSMutableArray *imageArr = [NSMutableArray array];
        [assetArr enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [JKImageManagement getPhotoWithAsset:obj targetSize:self.imageMaxSize?CGSizeMake(self.imageMaxSize, self.imageMaxSize):CGSizeMake(600, 600) resultHandler:^(UIImage *result, NSDictionary *info) {
                if (self.imageMaxSize?(result.size.width >= self.imageMaxSize):(result.size.width >= 600)) {
                    [imageArr addObject:result];
                }
                if (imageArr.count == assetArr.count) {
                    if (_JKDelegate && [_JKDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:)]) {
                        [_JKDelegate imagePickerController:self didFinishPickingPhotos:imageArr sourceAssets:assetArr isSelectOriginalPhoto:NO];
                    }
                }
            }];
        }];
    };
    imageList.returnSelectImage = ^(PHAsset *asset,CGRect rect) {
        if (rect.size.height == 0) {
            NSMutableArray *imageArr = [NSMutableArray array];
            [JKImageManagement getPhotoWithAsset:asset targetSize:self.imageMaxSize?CGSizeMake(self.imageMaxSize, self.imageMaxSize):CGSizeMake(600, 600) resultHandler:^(UIImage *result, NSDictionary *info) {
                if (self.imageMaxSize?(result.size.width >= self.imageMaxSize):(result.size.width >= 600)) {
                    [imageArr addObject:result];
                }
                
                if (_JKDelegate && [_JKDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingPhotos:sourceAssets:isSelectOriginalPhoto:)]) {
                    [_JKDelegate imagePickerController:self didFinishPickingPhotos:imageArr sourceAssets:@[asset] isSelectOriginalPhoto:NO];
                }
            }];
        } else {
            [JKImageManagement getPhotoWithAsset:asset targetSize:self.imageMaxSize?CGSizeMake(self.imageMaxSize, self.imageMaxSize):CGSizeMake(400, 400) cutRect:rect resultHandler:^(UIImage *result, NSDictionary *info) {
                if (_JKDelegate && [_JKDelegate respondsToSelector:@selector(imagePickerController:didFinishCutImage:cutType:)]) {
                    [_JKDelegate imagePickerController:self didFinishCutImage:result cutType:self.cutType];
                }
            }];
        }
    };
    [self pushViewController:imageList animated:NO];
}

@end
