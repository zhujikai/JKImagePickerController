//
//  ViewController.m
//  JKImagePickerController
//
//  Created by zjk on 2017/2/10.
//  Copyright © 2017年 zhuJiKai. All rights reserved.
//

#import "ViewController.h"
#import "JKImagePickerController.h"
#import "JKImageCell.h"
#import "JKPreviewController.h"

@interface ViewController ()<JKImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) NSArray *imageArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.imageCollectionView registerNib:[UINib nibWithNibName:@"JKImageCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"imageCell"];
    
    
}
- (IBAction)touchSelectOneImage:(id)sender {
    JKImagePickerController *picker = [[JKImagePickerController alloc] init];
    picker.selectMaxCount = 1;
    picker.JKDelegate = self;
    picker.cutType = cutImageSquare;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
- (IBAction)touchSelectManyimage:(id)sender {
    JKImagePickerController *picker = [[JKImagePickerController alloc] init];
    picker.selectMaxCount = 9;
    picker.JKDelegate = self;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}


- (void)imagePickerController:(JKImagePickerController *)picker didFinishCutImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)imagePickerController:(JKImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    self.imageArr = photos;
    [self.imageCollectionView reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JKImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    cell.imageView.image = self.imageArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JKPreviewController *previewCon = [[JKPreviewController alloc] init];
    previewCon.images = self.imageArr;
    previewCon.selectNumber = indexPath.row;
    previewCon.maxSelectCount = self.imageArr.count;
    [self presentViewController:previewCon animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
