//
//  ViewController.m
//  ZXVideoPlayer
//
//  Created by Shawn on 16/4/20.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "ViewController.h"
#import "VideoPlayViewController.h"
#import "ZXVideo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Home";
    self.tabBarItem.title = @"Home";
}

- (IBAction)playLocalVideo:(id)sender {
    
    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"150511_JiveBike" withExtension:@"mov"];
    ZXVideo *video = [[ZXVideo alloc] init];
    video.playUrl = videoURL.absoluteString;
    video.title = @"Test";
    
    VideoPlayViewController *vc = [[VideoPlayViewController alloc] init];
    vc.video = video;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)playRemoteVideo:(id)sender {
    
    ZXVideo *video = [[ZXVideo alloc] init];
    video.playUrl = @"http://baobab.wdjcdn.com/1451897812703c.mp4";
    video.title = @"Rollin'Wild 圆滚滚的";
    
    VideoPlayViewController *vc = [[VideoPlayViewController alloc] init];
    vc.video = video;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
