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
    
    [self configCollection];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configNav];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)configNav {
    
    UIButton *backBtn = ({
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
        backBtn.bounds = CGRectMake(0, 0, 30, 18);
        [backBtn addTarget:self action:@selector(touchPopView) forControlEvents:UIControlEventTouchUpInside];
        backBtn;
    });
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    if (self.maxSelectCount > 1) {
        
    } else {
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

- (void)configCollection {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionLayout.minimumInteritemSpacing = 0;
    collectionLayout.minimumLineSpacing = 0;
    collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.previewCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, PHONE_HEIGHT) collectionViewLayout:collectionLayout];
    
    self.previewCollectionView.delegate = self;
    self.previewCollectionView.dataSource = self;
    self.previewCollectionView.backgroundColor = [UIColor whiteColor];
    if (self.result.count > self.selectNumber) {
        [self.previewCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectNumber inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    } else if (self.assets.count > self.selectNumber) {
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

- (void)touchSelectFinish {
    if (_returnSelectImage) {
        JKPreviewCell *cell = (JKPreviewCell *)[self.previewCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        CGRect rect = [cell selectCutImageFinish];
        _returnSelectImage(self.assets.firstObject,rect);
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.result) {
        return self.result.count;
    }
    return self.assets.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JKPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JKPreviewCell" forIndexPath:indexPath];
    
    if (!cell.returnTap) {
        cell.returnTap = ^() {
            if (self.maxSelectCount > 1) {
                if (self.navigationController.navigationBar.hidden) {
                    self.navigationController.navigationBar.hidden = NO;
                } else {
                    self.navigationController.navigationBar.hidden = YES;
                }
            }
            
        };
    }
    
    if (!cell.returnDidScroll) {
        cell.returnDidScroll = ^(BOOL isDid) {
            if (isDid) {
                self.previewCollectionView.scrollEnabled = NO;
            } else {
                self.previewCollectionView.scrollEnabled = YES;
            }
        };
    }
    
    if (self.maxSelectCount > 1) {
        cell.isMultiple = YES;
    } else {
        cell.isMultiple = NO;
    }
    if (self.result) {
        if (self.result.count > indexPath.row) {
            cell.asset = self.result[indexPath.row];
        }
    } else {
        if (self.assets.count > indexPath.row) {
            cell.asset = self.assets[indexPath.row];
        }
    }
    cell.clipsToBounds = YES;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
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
    self.previewCollectionView = nil;
}


@end
