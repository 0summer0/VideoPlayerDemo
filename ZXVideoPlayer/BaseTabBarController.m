//
//  BaseTabBarController.m
//  ZXVideoPlayer
//
//  Created by Shawn on 16/4/29.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "BaseTabBarController.h"
#import "ViewController.h"
#import "VideoPlayViewController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotate
{
    UINavigationController *nav = self.viewControllers[0];
    if ([nav.topViewController isKindOfClass:[VideoPlayViewController class]]) {
        return ![[[NSUserDefaults standardUserDefaults] objectForKey:@"ZXVideoPlayer_DidLockScreen"] boolValue];
    }
    
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    UINavigationController *nav = self.viewControllers[0];
    if ([nav.topViewController isKindOfClass:[ViewController class]]) {
        return UIInterfaceOrientationMaskPortrait;
    }
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
