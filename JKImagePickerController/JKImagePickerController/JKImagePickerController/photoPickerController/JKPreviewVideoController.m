//
//  JKPreviewVideoController.m
//  JKImagePickerController
//
//  Created by zjk on 2017/3/10.
//  Copyright © 2017年 zhuJiKai. All rights reserved.
//

#import "JKPreviewVideoController.h"

//视频存储路径
#define KVideoUrlPath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VideoURL"]

@interface JKPreviewVideoController ()

@property (strong, nonatomic) UIView *bottonView;
@property (strong, nonatomic) UIImageView *playerImageView;

@property (strong, nonatomic) AVPlayer *plyer;

@property (strong, nonatomic) AVPlayerLayer *playerLayer;

@property (assign, nonatomic) BOOL isPlay;

@end

@implementation JKPreviewVideoController

- (UIImageView *)playerImageView {
    if (!_playerImageView) {
        _playerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MMVideoPreviewPlay"]];
        _playerImageView.frame = self.view.bounds;
        _playerImageView.contentMode = UIViewContentModeCenter;
    }
    return _playerImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    [self configVideo];
    [self configUI];
}

#pragma mark - 布局
- (void)configNav {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
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
        titleLab.text = @"视频预览";
        titleLab.textColor = [UIColor whiteColor];
        titleLab.frame = CGRectMake(0, 0, 80, 30);
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab;
    });
    self.navigationItem.titleView = titleLab;
    
}

- (void)configUI {
    self.view.backgroundColor = [UIColor blackColor];
    
    self.bottonView = [[UIView alloc] initWithFrame:CGRectMake(0, PHONE_HEIGHT - 44, PHONE_WIDTH, 44)];
    self.bottonView.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0];
    [self.view addSubview:self.bottonView];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = self.bottonView.bounds;
    [sureBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(touchSendVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.bottonView addSubview:sureBtn];
    [self.view bringSubviewToFront:self.bottonView];
}

- (void)configVideo {
    
        
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:self.videoUrl];
    
    self.plyer = [AVPlayer playerWithPlayerItem:playerItem];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.plyer];
    self.playerLayer.frame = self.view.bounds;
    
    [self.view.layer addSublayer:self.playerLayer];
    
    //AVPlayer播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.plyer.currentItem];
    
    [self.view addSubview:self.playerImageView];
}

- (void)moviePlayDidEnd:(id)sender
{
    [self.plyer seekToTime:kCMTimeZero];
    self.navigationController.navigationBar.hidden = NO;
    self.bottonView.hidden = NO;
    self.playerImageView.hidden = NO;
    self.isPlay = NO;
}


#pragma mark - 方法
- (void)touchBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchSendVideo {
    if (self.returnVideoUrl) {
        self.returnVideoUrl(self.videoUrl);
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isPlay) {
        [self.plyer pause];
        self.navigationController.navigationBar.hidden = NO;
        self.bottonView.hidden = NO;
        self.playerImageView.hidden = NO;
    } else {
        [self.plyer play];
        self.navigationController.navigationBar.hidden = YES;
        self.bottonView.hidden = YES;
        self.playerImageView.hidden = YES;
    }
    self.isPlay = !self.isPlay;
}

@end
