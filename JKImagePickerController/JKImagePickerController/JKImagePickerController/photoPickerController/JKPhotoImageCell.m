//
//  JKPhotoImageCell.m
//  JKImagePickerController
//
//  Created by zjk on 2017/2/10.
//  Copyright © 2017年 zhuJiKai. All rights reserved.
//

#import "JKPhotoImageCell.h"

@implementation JKPhotoImageCell

- (void)layoutSubviews {
    [self configCell];
}


- (void)configCell {
    if (!self.isLayout) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, CELL_WIDTH)];
        self.imageView.tag = 1;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        self.isLayout = YES;
        
        if (self.videoImageView) {
            [self addSubview:self.videoImageView];
        }
        if (self.videoTimeLab) {
            [self addSubview:self.videoTimeLab];
        }
        if (self.isMultiple) {
            [self addSubview:self.selectBtn];
        }
    }
}

- (void)configSubViewWithMediaType:(PHAssetMediaType)mediaType {
    switch (mediaType) {
        case PHAssetMediaTypeVideo:
        {
            self.videoTimeLab.hidden = NO;
            self.videoImageView.hidden = NO;
            self.selectBtn.hidden = YES;
        }
            break;
        case PHAssetMediaTypeImage:
        {
            self.videoTimeLab.hidden = YES;
            self.videoImageView.hidden = YES;
            self.selectBtn.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake(CELL_WIDTH - 32, 0, 32, 32);
        [_selectBtn setImage:[UIImage imageNamed:@"photo_def_previewVc"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"photo_sel_photoPickerVc"] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(touchSelectImage) forControlEvents:UIControlEventTouchUpInside];
        _selectBtn.contentMode = UIViewContentModeCenter;
    }
    return _selectBtn;
}

- (UIImageView *)videoImageView {
    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VideoSendIcon"]];
        _videoImageView.frame = CGRectMake(5, CELL_WIDTH - 22, 19, 19);
    }
    return _videoImageView;
}

- (UILabel *)videoTimeLab {
    if (!_videoTimeLab) {
        _videoTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(28, CELL_WIDTH - 23, 60, 23)];
        _videoTimeLab.font = [UIFont systemFontOfSize:13];
        _videoTimeLab.textColor = [UIColor whiteColor];
    }
    return _videoTimeLab;
}

- (void)touchSelectImage {
    if (self.returnSelect) {
        BOOL isSuccess = self.returnSelect(!self.selectBtn.selected);
        if (isSuccess) {
            self.selectBtn.selected = !self.selectBtn.selected;
            if (self.selectBtn.selected) {
                [self springAnimationWithView:self.selectBtn];
            }
        }
    }
}

- (void)springAnimationWithView:(UIView *)springView {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [springView.layer addAnimation:animation forKey:nil];
}

- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    [self configSubViewWithMediaType:asset.mediaType];
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        
        self.videoTimeLab.text = [NSString stringWithFormat:@"%02d:%02d",(int)asset.duration / 60,(int)(round((asset.duration * 10) / 10) ) % 60];
    }
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    [imageManager requestImageForAsset:asset
                            targetSize:CGSizeMake(CELL_WIDTH * 1.2, CELL_WIDTH * 1.2)
                           contentMode:PHImageContentModeAspectFill
                               options:nil
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             // 得到一张 UIImage，展示到界面上
                             self.imageView.image = result;
                         }];
}

- (void)dealloc {
    self.imageView.image = nil;
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    [self.selectBtn removeFromSuperview];
    self.selectBtn = nil;
    [self.videoImageView removeFromSuperview];
    self.videoImageView = nil;
    [self.videoTimeLab removeFromSuperview];
    self.videoTimeLab = nil;
    self.asset = nil;
}


@end
