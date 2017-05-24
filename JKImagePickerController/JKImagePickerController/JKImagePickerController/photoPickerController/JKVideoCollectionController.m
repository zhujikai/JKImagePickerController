//
//  JKVideoCollectionController.m
//  JKImagePickerController
//
//  Created by zjk on 2017/3/10.
//  Copyright © 2017年 zhuJiKai. All rights reserved.
//

#import "JKVideoCollectionController.h"
#import "JKPhotoImageCell.h"
#import "JKImageManagement.h"


@interface JKVideoCollectionController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *videoCollection;

@property (strong, nonatomic) PHFetchResult *result;

@end

@implementation JKVideoCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNav];
    [self configCollection];
    [self configDataSoureImage];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

#pragma mark - 布局
- (void)configNav {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIButton *backBtn = ({
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        backBtn.bounds = CGRectMake(0, 0, 30, 18);
        [backBtn addTarget:self action:@selector(touchBack) forControlEvents:UIControlEventTouchUpInside];
        backBtn;
    });
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    UILabel *titleLab = ({
        titleLab = [[UILabel alloc] init];
        titleLab.text = @"视频";
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
    
    self.videoCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, PHONE_WIDTH, PHONE_HEIGHT - 64) collectionViewLayout:collectionLayout];
    self.videoCollection.delegate = self;
    self.videoCollection.dataSource = self;
    self.videoCollection.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.videoCollection];
    
    [self.videoCollection registerClass:[JKPhotoImageCell class] forCellWithReuseIdentifier:@"JKPhotoImageCell"];
}

- (void)configDataSoureImage {
        if ([JKImageManagement isCanUsePhotos] == noRequest) {
            [JKImageManagement usePhotos:^(BOOL status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status) {
                        self.result = [JKImageManagement getAllVideo];
                        if (self.result.count) {
                            [self.videoCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.result.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
                        }
                        [self.videoCollection reloadData];
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
            self.result = [JKImageManagement getAllVideo];
            if (self.result.count) {
                [self.videoCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.result.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            }
            [self.videoCollection reloadData];
        }
    
}

#pragma mark - 方法
- (void)touchBack {
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelController {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.result.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JKPhotoImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JKPhotoImageCell" forIndexPath:indexPath];
    
    cell.asset = self.result[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CELL_WIDTH, CELL_WIDTH);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PHAsset *asset = self.result[indexPath.row];
    
    __weak typeof(asset) weakAsset = asset;
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        AVURLAsset *urlAsset = (AVURLAsset *)asset;
        NSURL *url = urlAsset.URL;
        /** 若要去 url 的 data，需要将 url.aboutString 的前缀"file://" 去掉 */
        dispatch_async(dispatch_get_main_queue(), ^{
            JKPreviewVideoController *previewVideo = [[JKPreviewVideoController alloc] init];
            previewVideo.asset = weakAsset;
            previewVideo.videoUrl = url;
            previewVideo.returnVideoUrl = ^(NSURL *url) {
                if (self.returnVideoUrl) {
                    self.returnVideoUrl(url);
                }
            };
            [self.navigationController pushViewController:previewVideo animated:YES];
        });
    }];
}

@end
