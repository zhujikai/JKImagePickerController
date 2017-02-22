//
//  JKImageListController.m
//  JKImagePickerController
//
//  Created by zjk on 2017/2/10.
//  Copyright © 2017年 zhuJiKai. All rights reserved.
//

#import "JKImageListController.h"
#import "JKImageCollectionController.h"
#import "JKImageManagement.h"
#import "JKImageListCell.h"

@interface JKImageListController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *dataSoureArray;

@property (strong, nonatomic) UITableView *photoListView;

@end

@implementation JKImageListController

- (void)viewDidLoad {
    [super viewDidLoad];
    JKImageCollectionController *imageCon = [[JKImageCollectionController alloc] init];
    imageCon.navTitle = @"所有照片";
    imageCon.maxSelectCount = self.maxSelectCount;
    imageCon.returnSelectImageAsset = ^(NSArray<PHAsset *>* assets) {
        if (self.returnSelectImageAsset) {
            self.returnSelectImageAsset(assets);
        }
    };
    imageCon.returnSelectImage = ^(PHAsset *asset, CGRect rect) {
        if (self.returnSelectImage) {
            self.returnSelectImage(asset,rect);
        }
    };
    [self.navigationController pushViewController:imageCon animated:NO];
    [self configNav];
    [self configView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getPhotoList];
}

#pragma mark - 布局
- (void)configNav {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UILabel *titleLab = ({
        titleLab = [[UILabel alloc] init];
        titleLab.text = @"照片";
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

- (void)configView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.photoListView = ({
        self.photoListView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, PHONE_WIDTH, PHONE_HEIGHT)];
        self.photoListView.backgroundColor = [UIColor whiteColor];
        self.photoListView.delegate = self;
        self.photoListView.dataSource = self;
        self.photoListView;
    });
    
    [self.view addSubview:self.photoListView];
}

#pragma mark - 方法
- (void)cancelController {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)getPhotoList {
    self.dataSoureArray =  [JKImageManagement getAlbums];
    [self.photoListView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSoureArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JKImageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[JKImageListCell alloc] initWithStyle:3 reuseIdentifier:@"cell"];
    }
    
    PHAssetCollection *assetCollection = self.dataSoureArray[indexPath.row];
    
    cell.accessoryType = 1;
    cell.clipsToBounds = YES;
    cell.albumNamelab.text = [NSString stringWithFormat:@"%@ (%lu)",[JKImageManagement transformAblumTitle:assetCollection.localizedTitle],(unsigned long)[JKImageManagement getFetchResultWithAssetCollection:assetCollection].count];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([JKImageManagement getFetchResultWithAssetCollection:assetCollection].count) {
        [JKImageManagement getPhotoWithAsset:[JKImageManagement getFetchResultWithAssetCollection:assetCollection].lastObject targetSize:CGSizeMake(70, 70) resultHandler:^(UIImage *result, NSDictionary *info) {
            cell.photoImageView.image = result;
        }];
    } else {
        cell.photoImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"imageDownloadFail" ofType:@"png"]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PHAssetCollection *assetCollection = self.dataSoureArray[indexPath.row];
    
    JKImageCollectionController *imageCon = [[JKImageCollectionController alloc] init];
    imageCon.smartAlbum = [JKImageManagement getFetchResultWithAssetCollection:assetCollection];
    imageCon.navTitle = [JKImageManagement transformAblumTitle:assetCollection.localizedTitle];
    imageCon.maxSelectCount = self.maxSelectCount;
    
    imageCon.returnSelectImageAsset = ^(NSArray<PHAsset *>* assets) {
        if (self.returnSelectImageAsset) {
            self.returnSelectImageAsset(assets);
        }
    };
    
    imageCon.returnSelectImage = ^(PHAsset *asset, CGRect rect) {
        if (self.returnSelectImage) {
            self.returnSelectImage(asset,rect);
        }
    };
    
    [self.navigationController pushViewController:imageCon animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PHAssetCollection *assetCollection = self.dataSoureArray[indexPath.row];
    if (![JKImageManagement transformAblumTitle:assetCollection.localizedTitle]) {
        return 0;
    }
    return 50;
}

- (void)dealloc {
    [self.photoListView removeFromSuperview];
    self.photoListView = nil;
}

@end
