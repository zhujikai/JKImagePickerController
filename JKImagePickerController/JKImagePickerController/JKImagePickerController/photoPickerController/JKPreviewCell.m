//
//  JKPreviewCell.m
//  JKImagePickerController
//
//  Created by zjk on 2017/2/13.
//  Copyright © 2017年 zhuJiKai. All rights reserved.
//

#import "JKPreviewCell.h"
#import "JKImageManagement.h"
#import "JKCutImageScaleView.h"

@implementation JKPreviewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configCell];
        [self configBottonView];
        [self configGesture];
    }
    return self;
}

- (void)configCell {
    
    self.backScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.backScrollView.contentSize = [UIScreen mainScreen].bounds.size;
    self.backScrollView.backgroundColor = [UIColor blackColor];
    self.backScrollView.bouncesZoom = YES;
    self.backScrollView.maximumZoomScale = 2.5;
    self.backScrollView.minimumZoomScale = 1.0;
    self.backScrollView.delegate = self;
    
    [self.contentView addSubview:self.backScrollView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.clipsToBounds = YES;
    [self addSubview:_imageView];
    
    [self.backScrollView addSubview:self.imageView];
    
}

- (void)configBottonView {
    if (self.isMultiple) {
        
    } else {
        
    }
}

- (void)configGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.backScrollView addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *tapTwoGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapTwo:)];
    tapTwoGesture.numberOfTapsRequired = 2;
    [self.backScrollView addGestureRecognizer:tapTwoGesture];
    
    [tapGesture requireGestureRecognizerToFail:tapTwoGesture];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    if (self.returnTap) {
        self.returnTap();
    }
}

- (void)handleTapTwo:(UITapGestureRecognizer *)recognizer {
    if (self.backScrollView.zoomScale == 1) {
        float newScale = self.backScrollView.zoomScale * 2.5;//zoomScale这个值决定了contents当前扩展的比例
        
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[recognizer locationInView:recognizer.view]];
        
        [self.backScrollView zoomToRect:zoomRect animated:YES];
    } else {
        CGRect zoomRect = [self zoomRectForScale:1 withCenter:CGPointMake(PHONE_WIDTH / 2, PHONE_HEIGHT / 2)];
        if (!self.isMultiple) {
            self.backScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        
        [self.backScrollView zoomToRect:zoomRect animated:YES];
    }
    
}

- (void)addScaleView:(NSInteger)type {
    //self.scaleView = nil;
    [self.contentView addSubview:self.scaleView];
}

- (JKCutImageScaleView *)scaleView {
    if (!_scaleView) {
        _scaleView = [[JKCutImageScaleView alloc] init];
        _scaleView.frame = [UIScreen mainScreen].bounds;
        _scaleView.backgroundColor = [UIColor clearColor];
    }
    return _scaleView;
}


- (CGRect)selectCutImageFinish {
    CGFloat cutX;
    CGFloat cutY;
    
    //变化比例
    CGFloat transformScale = self.imageView.transform.a;

    if (self.imageView.image.size.height > self.imageView.image.size.width) {
        cutY = ((self.imageView.frame.size.height - PHONE_WIDTH) / 2) + self.backScrollView.contentOffset.y - ((self.imageView.frame.size.height - PHONE_HEIGHT)>0?((self.imageView.frame.size.height - PHONE_HEIGHT) / 2):0);
        cutX = self.backScrollView.contentOffset.x / transformScale;
        return CGRectMake(cutX / PHONE_WIDTH, cutY / self.imageView.frame.size.height, (PHONE_WIDTH / transformScale) / PHONE_WIDTH, PHONE_WIDTH / self.imageView.frame.size.height);
    } else {
        cutY = (((self.imageView.frame.size.height - PHONE_WIDTH) / 2) + self.backScrollView.contentOffset.y);
        cutX = (self.backScrollView.contentOffset.x / transformScale) + ((PHONE_WIDTH - self.imageView.frame.size.height)<0?0:(PHONE_WIDTH - self.imageView.frame.size.height) / 2);
        if (cutY < 0) {
            cutY = 0;
        }
        return CGRectMake(cutX / PHONE_WIDTH, self.imageView.frame.size.height < PHONE_WIDTH?1:(cutY / self.imageView.frame.size.height), (PHONE_WIDTH - ((PHONE_WIDTH - self.imageView.frame.size.height)<0?0:(PHONE_WIDTH - self.imageView.frame.size.height))) / self.imageView.frame.size.width, (PHONE_WIDTH / self.imageView.frame.size.height)>1?1:(PHONE_WIDTH / self.imageView.frame.size.height));
    }
}


#pragma mark - UIScrollViewDelegate

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height =self.frame.size.height / scale;
    zoomRect.size.width  =self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (!self.isMultiple) {
        if (self.imageView.frame.size.height / PHONE_WIDTH > 1) {
            if (self.imageView.frame.size.height > PHONE_HEIGHT) {
                self.backScrollView.contentInset = UIEdgeInsetsMake((PHONE_HEIGHT - PHONE_WIDTH) / 2, 0, (PHONE_HEIGHT - PHONE_WIDTH) / 2, 0);
            } else {
                self.backScrollView.contentSize = CGSizeMake(self.backScrollView.contentSize.width, PHONE_HEIGHT);
                self.backScrollView.contentInset = UIEdgeInsetsMake(((self.imageView.frame.size.height) - PHONE_WIDTH) / 2, 0, ((self.imageView.frame.size.height) - PHONE_WIDTH) / 2, 0);
            }
        } else {
            self.backScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.returnDidScroll) {
        self.returnDidScroll(YES);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.returnDidScroll) {
        self.returnDidScroll(NO);
    }
}

- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    self.backScrollView.contentSize = [UIScreen mainScreen].bounds.size;
    self.backScrollView.zoomScale = 1;
    if (self.isMultiple) {
        self.backScrollView.bounces = NO;
    } else {
        self.backScrollView.bounces = YES;
    }
    
    self.imageView.image = nil;
    [JKImageManagement getPhotoWithAsset:self.asset targetSize:CGSizeMake(800, 800) resultHandler:^(UIImage *result, NSDictionary *info) {
        self.imageView.image = result;
        if (result) {
            if ((result.size.height / result.size.width) > (PHONE_HEIGHT / PHONE_WIDTH)) {
                self.imageView.frame = CGRectMake((PHONE_WIDTH - (result.size.width / result.size.height * PHONE_HEIGHT)) / 2, 0, result.size.width / result.size.height * PHONE_HEIGHT, PHONE_HEIGHT);
            } else {
                self.imageView.frame = CGRectMake(0, (PHONE_HEIGHT - (result.size.height / result.size.width * PHONE_WIDTH)) / 2, PHONE_WIDTH, result.size.height / result.size.width * PHONE_WIDTH);
            }
        }
        if (!self.isMultiple) {
            [self addScaleView:1];
            if (result) {
                if (result.size.height / result.size.width > 1) {
                    self.backScrollView.contentInset = UIEdgeInsetsMake(((result.size.height / result.size.width * PHONE_WIDTH) - PHONE_WIDTH) / 2, 0, ((result.size.height / result.size.width * PHONE_WIDTH) - PHONE_WIDTH) / 2, 0);
                }
            }
        }
    }];
}

- (void)dealloc {
    self.backScrollView = nil;
    self.imageView = nil;
    self.asset = nil;
    self.scaleView = nil;
}

@end
