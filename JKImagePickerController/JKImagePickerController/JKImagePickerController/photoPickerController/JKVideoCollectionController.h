//
//  JKVideoCollectionController.h
//  JKImagePickerController
//
//  Created by zjk on 2017/3/10.
//  Copyright © 2017年 zhuJiKai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKPreviewVideoController.h"

@interface JKVideoCollectionController : UIViewController

@property (copy, nonatomic) void (^returnVideoUrl)(NSURL *);

@end
