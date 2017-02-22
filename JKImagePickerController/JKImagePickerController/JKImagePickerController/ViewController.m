//
//  ViewController.m
//  JKImagePickerController
//
//  Created by zjk on 2017/2/10.
//  Copyright © 2017年 zhuJiKai. All rights reserved.
//

#import "ViewController.h"
#import "JKImagePickerController.h"

@interface ViewController ()<JKImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)touchSelectOneImage:(id)sender {
    JKImagePickerController *picker = [[JKImagePickerController alloc] init];
    picker.selectMaxCount = 1;
    picker.JKDelegate = self;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
- (IBAction)touchSelectManyimage:(id)sender {
    JKImagePickerController *picker = [[JKImagePickerController alloc] init];
    picker.selectMaxCount = 9;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}


- (void)imagePickerController:(JKImagePickerController *)picker didFinishCutImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
