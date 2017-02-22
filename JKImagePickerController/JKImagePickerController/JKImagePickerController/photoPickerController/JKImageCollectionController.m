//
//  JKImagePickerController.m
//  JKImagePickerController
//
//  Created by zjk on 2017/2/10.
//  Copyright © 2017年 zhuJiKai. All rights reserved.
//

#import "JKImageCollectionController.h"
#import "JKPhotoImageCell.h"
#import "JKPreviewController.h"

#import "JKImageManagement.h"

@interface JKImageCollectionController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *imageCollection;

@property (strong, nonatomic) UIButton *sureBtn;
@property (strong, nonatomic) UIImageView *selectImageCountBackview;
@property (strong, nonatomic) UILabel *selectImageCountLab;

@property (strong, nonatomic) PHFetchResult *result;

@property (strong, nonatomic) NSMutableSet *selectTypeSet;

@end

@implementation JKImageCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configCollection];
    if (self.maxSelectCount > 1) {
        [self configBottonView];
    }
    [self configDataSoureImage];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - 布局
- (void)configNav {
    
    UIButton *backBtn = ({
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
        backBtn.bounds = CGRectMake(0, 0, 30, 18);
        [backBtn addTarget:self action:@selector(touchBack) forControlEvents:UIControlEventTouchUpInside];
        backBtn;
    });
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    UILabel *titleLab = ({
        titleLab = [[UILabel alloc] init];
        titleLab.text = self.navTitle;
        titleLab.textColor = [UIColor whiteColor];
        titleLab.frame = CGRectMake(0, 0, 80, 30);
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab;
    });
    self.navigationItem.titleView = titleLab;
    
    UIButton *cancelBtn = ({
        cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        cancelBtn.bounds = CGRectMake(0, 0, 40, 30);
        [cancelBtn addTarget:self action:@selector(cancelController) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn;
    });
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
}

- (void)configCollection {
    
    UICollectionViewFlowLayout *collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionLayout.minimumInteritemSpacing = 0.5;
    collectionLayout.minimumLineSpacing = 2;
    collectionLayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    
    self.imageCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, PHONE_WIDTH, self.maxSelectCount>1?PHONE_HEIGHT - 44 - 64:PHONE_HEIGHT - 64) collectionViewLayout:collectionLayout];
    self.imageCollection.delegate = self;
    self.imageCollection.dataSource = self;
    self.imageCollection.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageCollection];
    
    [self.imageCollection registerClass:[JKPhotoImageCell class] forCellWithReuseIdentifier:@"JKPhotoImageCell"];
}

- (void)configBottonView {
    UIView *bottonView = [[UIView alloc] init];
    bottonView.frame = CGRectMake(0, PHONE_HEIGHT - 44, PHONE_WIDTH, 44);
    bottonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottonView];
    
    UIView *lineView = ({
        lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, 0, PHONE_WIDTH, 1);
        lineView.backgroundColor = [UIColor colorWithRed:240/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        lineView;
    });
    [bottonView addSubview:lineView];
    
    self.sureBtn = ({
        self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:[UIColor colorWithRed:0.15 green:0.75 blue:0.15 alpha:1] forState:UIControlStateNormal];
        [self.sureBtn addTarget:self action:@selector(touchSelectPhotoFinish) forControlEvents:UIControlEventTouchUpInside];
        self.sureBtn.frame = CGRectMake(PHONE_WIDTH - 80, 0, 80, 44);
        self.sureBtn;
    });
    [self touchSetBtnWithEnabled:NO];
    [bottonView addSubview:self.sureBtn];
    
    self.selectImageCountBackview = ({
        self.selectImageCountBackview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"preview_number_icon"]];
        self.selectImageCountBackview.frame = CGRectMake(PHONE_WIDTH - 90, 9, 26, 26);
        self.selectImageCountBackview.hidden = YES;
        self.selectImageCountBackview;
    });
    [bottonView addSubview:self.selectImageCountBackview];
    
    self.selectImageCountLab = ({
        self.selectImageCountLab = [[UILabel alloc] initWithFrame:CGRectMake(PHONE_WIDTH - 90, 9, 26, 26)];
        self.selectImageCountLab.textColor = [UIColor whiteColor];
        self.selectImageCountLab.font = [UIFont systemFontOfSize:15 weight:0.4];
        self.selectImageCountLab.text = @"0";
        self.selectImageCountLab.textAlignment = NSTextAlignmentCenter;
        self.selectImageCountLab.hidden = YES;
        self.selectImageCountLab;
    });
    [bottonView addSubview:self.selectImageCountLab];
}

- (void)configDataSoureImage {
    if (self.smartAlbum) {
        self.result = self.smartAlbum;
        if (self.result.count) {
            [self.imageCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.result.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        }
        [self.imageCollection reloadData];
    } else {
        if ([JKImageManagement isCanUsePhotos] == noRequest) {
            [JKImageManagement UsePhotos:^(BOOL status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status) {
                        self.result = [JKImageManagement getAllPhoto];
                        if (self.result.count) {
                            [self.imageCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.result.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
                        }
                        [self.imageCollection reloadData];
                    } else {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你拒绝了应用使用相册的权限，请先开启相册权限" message:nil preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [self cancelController];
                        }];
                        [alert addAction:sureAction];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                });
            }];
        } else if ([JKImageManagement isCanUsePhotos] == noUse) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"你拒绝了应用使用相册的权限，请先开启相册权限" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self cancelController];
            }];
            [alert addAction:sureAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            self.result = [JKImageManagement getAllPhoto];
            if (self.result.count) {
                [self.imageCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.result.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            }
            [self.imageCollection reloadData];
        }
    }
    
}

#pragma mark - 懒加载
- (NSMutableSet *)selectTypeSet {
    if (!_selectTypeSet) {
        _selectTypeSet = [[NSMutableSet alloc] init];
    }
    return _selectTypeSet;
}

#pragma mark - 方法
- (void)touchBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchSetBtnWithEnabled:(BOOL)enabled {
    self.sureBtn.enabled = enabled;
    if (enabled) {
        self.sureBtn.alpha = 1;
    } else {
        self.sureBtn.alpha = 0.4;
    }
}

- (void)touchSelectPhotoFinish {
    if (self.returnSelectImageAsset) {
        NSMutableArray *array = [NSMutableArray array];
        [self.selectTypeSet enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            [array addObject:self.result[[obj integerValue]]];
        }];
        self.returnSelectImageAsset(array);
    }
}

- (void)setSelectImageCountLabWithCount:(int)count {
    if (!count) {
        self.selectImageCountLab.hidden = YES;
        self.selectImageCountBackview.hidden = YES;
    } else {
        self.selectImageCountBackview.hidden = NO;
        self.selectImageCountLab.hidden = NO;
        self.selectImageCountLab.text = [NSString stringWithFormat:@"%d",count];
        [self springAnimationWithView:self.selectImageCountBackview];
    }
}

- (void)cancelController {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)springAnimationWithView:(UIView *)springView {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.4;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [springView.layer addAnimation:animation forKey:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.result.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JKPhotoImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JKPhotoImageCell" forIndexPath:indexPath];
    
    //选中&反选中回调
    __weak typeof(self) weakSelf = self;
    cell.returnSelect = ^(BOOL isSelect) {
        if (isSelect) {
            if (weakSelf.selectTypeSet.count < self.maxSelectCount) {
                [weakSelf.selectTypeSet addObject:@(indexPath.row)];
                [weakSelf setSelectImageCountLabWithCount:(int)weakSelf.selectTypeSet.count];
                [weakSelf touchSetBtnWithEnabled:YES];
                return YES;
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"最多选择%d张照片",weakSelf.maxSelectCount] message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:sureAction];
                
                [self presentViewController:alert animated:YES completion:nil];
                return NO;
            }
        } else {
            if ([weakSelf.selectTypeSet containsObject:@(indexPath.row)]) {
                [weakSelf.selectTypeSet removeObject:@(indexPath.row)];
                [weakSelf setSelectImageCountLabWithCount:(int)weakSelf.selectTypeSet.count];
                if (!weakSelf.selectTypeSet.count) {
                    [weakSelf touchSetBtnWithEnabled:NO];
                }
            }
            return YES;
        }
    };
    
    //判断是否被选中
    if ([self.selectTypeSet containsObject:@(indexPath.row)]) {
        cell.selectBtn.selected = YES;
    } else {
        cell.selectBtn.selected = NO;
    }
    
    cell.isMultiple = self.maxSelectCount>1?YES:NO;
    cell.asset = self.result[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CELL_WIDTH, CELL_WIDTH);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = self.result[indexPath.row];
    if (asset.mediaType == PHAssetMediaTypeImage) {
        JKPreviewController *preview = [[JKPreviewController alloc] init];
        if ([self.selectTypeSet containsObject:@(indexPath.row)]) {
            NSMutableArray *array = [NSMutableArray array];
            NSArray *keyArr = self.selectTypeSet.allObjects;
            NSArray *keyUpArray = [keyArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2];
            }];
            [keyUpArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqual:@(indexPath.row)]) {
                    preview.selectNumber = idx;
                }
                [array addObject:self.result[[obj integerValue]]];
                if (stop) {
                    preview.assets = array;
                }
            }];
            
        } else {
            if (self.maxSelectCount > 1) {
                preview.result = self.result;
                preview.selectNumber = indexPath.row;
            } else {
                preview.assets = @[self.result[indexPath.row]];
                preview.selectNumber = 0;
            }
            
        }
        
        preview.maxSelectCount = self.maxSelectCount;
        preview.returnSelectImage = ^(PHAsset *asset, CGRect rect) {
            if (self.returnSelectImage) {
                self.returnSelectImage(asset,rect);
            }
        };
        
        [self.navigationController pushViewController:preview animated:YES];
    } else if(asset.mediaType == PHAssetMediaTypeVideo) {
        
    } else if(asset.mediaType == PHAssetMediaTypeAudio) {
        
    } else {
        
    }
}

- (void)dealloc {
    [self.imageCollection removeFromSuperview];
    self.imageCollection = nil;
    self.result = nil;
    self.selectTypeSet = nil;
    self.smartAlbum = nil;
}

@end
