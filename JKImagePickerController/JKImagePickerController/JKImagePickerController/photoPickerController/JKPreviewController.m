//
//  JKPreviewController.m
//  JKImagePickerController
//
//  Created by zjk on 2017/2/13.
//  Copyright © 2017年 zhuJiKai. All rights reserved.
//

#import "JKPreviewController.h"
#import "JKPreviewCell.h"
#import "JKImageManagement.h"

@interface JKPreviewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *previewCollectionView;

@end

@implementation JKPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    if (self.maxSelectCount != 1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self configCollection];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configNav];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

/**
 设置界面
 */
- (void)configNav {
    
    UIButton *backBtn = ({
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
        backBtn.bounds = CGRectMake(0, 0, 30, 18);
        [backBtn addTarget:self action:@selector(touchPopView) forControlEvents:UIControlEventTouchUpInside];
        backBtn;
    });
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    if (self.maxSelectCount == 1) {
        //当只有一张图片时的界面
        self.navigationController.navigationBar.hidden = YES;
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, PHONE_HEIGHT - 49, PHONE_WIDTH / 2, 49);
        [cancelBtn setBackgroundColor:[UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:0.5]];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(touchPopView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cancelBtn];
        
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame = CGRectMake(PHONE_WIDTH / 2, PHONE_HEIGHT - 49, PHONE_WIDTH / 2, 49);
        [sureBtn setBackgroundColor:[UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:0.5]];
        [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(touchSelectFinish) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:sureBtn];
    }
}

/**
 设置collectionView
 */
- (void)configCollection {
    
    
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionLayout.minimumInteritemSpacing = 0;
    collectionLayout.minimumLineSpacing = 0;
    collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    if (self.maxSelectCount == 1) {
        self.previewCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, PHONE_HEIGHT) collectionViewLayout:collectionLayout];
    } else {
        self.previewCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, -64, PHONE_WIDTH, PHONE_HEIGHT) collectionViewLayout:collectionLayout];
    }
    
    self.previewCollectionView.delegate = self;
    self.previewCollectionView.dataSource = self;
    self.previewCollectionView.backgroundColor = [UIColor blackColor];
    //设置当前选中的图片
    if (self.result.count > self.selectNumber || self.assets.count > self.selectNumber || self.images.count > self.selectNumber ||  self.urls.count > self.selectNumber) {
        [self.previewCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectNumber inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
    
    self.previewCollectionView.pagingEnabled = YES;
    
    [self.view addSubview:self.previewCollectionView];
    
    [self.previewCollectionView registerClass:[JKPreviewCell class] forCellWithReuseIdentifier:@"JKPreviewCell"];
}

#pragma mark - 事件方法
- (void)touchPopView {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 当只有一张图片时点击完成时调用
 */
- (void)touchSelectFinish {
    if (_returnSelectImage) {
        
        CGRect rect;
        
        if (self.cutType == 1) {
            JKPreviewCell *cell = (JKPreviewCell *)[self.previewCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            rect = [cell selectCutImageFinish];
            
        } else {
            rect = CGRectMake(0, 0, 0, 0);
        }
        
        _returnSelectImage(self.assets.firstObject,rect);
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.result) {
        return self.result.count;
    } else if (self.assets) {
        return self.assets.count;
    } else if (self.images) {
        return self.images.count;
    } else {
        return self.urls.count;
    }
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JKPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JKPreviewCell" forIndexPath:indexPath];
    
    //点击事件
    if (!cell.returnTap) {
        cell.returnTap = ^() {
            if (self.images.count) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                if (self.maxSelectCount != 1) {
                    if (self.navigationController.navigationBar.hidden) {
                        self.navigationController.navigationBar.hidden = NO;
                    } else {
                        self.navigationController.navigationBar.hidden = YES;
                    }
                }
            }
        };
    }
    
    //滑动开始与结束（isDid YES&NO）
    if (!cell.returnDidScroll) {
        cell.returnDidScroll = ^(BOOL isDid) {
            if (isDid) {
                self.previewCollectionView.scrollEnabled = NO;
            } else {
                self.previewCollectionView.scrollEnabled = YES;
            }
        };
    }
    
    //是否是多张图片
    if (self.maxSelectCount != 1) {
        cell.isMultiple = YES;
    } else {
        cell.isMultiple = NO;
    }
    //裁剪类型
    cell.cutType = self.cutType;
    
    //给cell传图片或者PHAsset
    if (self.result) {
        if (self.result.count > indexPath.row) {
            cell.asset = self.result[indexPath.row];
        }
    } else if (self.assets) {
        if (self.assets.count > indexPath.row) {
            cell.asset = self.assets[indexPath.row];
        }
    } else if (self.images) {
        if (self.images.count > indexPath.row) {
            cell.image = self.images[indexPath.row];
        }
    } else {
        if (self.urls.count > indexPath.row) {
//            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.urls[indexPath.row]] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                
//            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                cell.image = image;
//            }];
            
        }
    }
    cell.clipsToBounds = YES;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.images) {
        return CGSizeMake(PHONE_WIDTH, PHONE_HEIGHT);
    }
    if (self.urls) {
        return CGSizeMake(PHONE_WIDTH, PHONE_HEIGHT);
    }
    
    //过滤video或者audio
    PHAsset *asset;
    if (self.result) {
        if (self.result.count > indexPath.row) {
            asset = self.result[indexPath.row];
        }
    } else {
        if (self.assets.count > indexPath.row) {
            asset = self.assets[indexPath.row];
        }
    }
    if (asset.mediaType == PHAssetMediaTypeImage) {
        return CGSizeMake(PHONE_WIDTH, PHONE_HEIGHT);
    }
    return CGSizeMake(0, 0);
}

- (void)dealloc {
    self.assets = nil;
    self.result = nil;
    self.images = nil;
    self.urls = nil;
    self.previewCollectionView = nil;
}


@end
