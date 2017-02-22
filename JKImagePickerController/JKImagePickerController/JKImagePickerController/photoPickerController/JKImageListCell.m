//
//  JKImageListCell.m
//  JKImagePickerController
//
//  Created by zjk on 2017/2/10.
//  Copyright © 2017年 zhuJiKai. All rights reserved.
//

#import "JKImageListCell.h"

@implementation JKImageListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configCellSubview];
    }
    return self;
}

- (void)configCellSubview {
    self.photoImageView = ({
        self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.photoImageView.clipsToBounds = YES;
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoImageView;
    });
    [self.contentView addSubview:self.photoImageView];
    
    self.albumNamelab = ({
        self.albumNamelab = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 300, 50)];
        self.albumNamelab.textColor = [UIColor blackColor];
        self.albumNamelab.font = [UIFont systemFontOfSize:17];
        self.albumNamelab;
    });
    [self.contentView addSubview:self.albumNamelab];
}

- (void)dealloc {
    self.photoImageView = nil;
    self.albumNamelab = nil;
}


@end
