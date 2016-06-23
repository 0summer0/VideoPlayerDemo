//
//  ZXVideoPlayerController.h
//  ZXVideoPlayer
//
//  Created by Shawn on 16/4/21.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXVideo.h"
@import MediaPlayer;

#define kZXVideoPlayerOriginalWidth  MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define kZXVideoPlayerOriginalHeight (kZXVideoPlayerOriginalWidth * (11.0 / 16.0))

@interface ZXVideoPlayerController : MPMoviePlayerController

@property (nonatomic, assign) CGRect frame;
/// video model
@property (nonatomic, strong, readwrite) ZXVideo *video;
/// 竖屏模式下点击返回
@property (nonatomic, copy) void(^videoPlayerGoBackBlock)(void);
/// 将要切换到竖屏模式
@property (nonatomic, copy) void(^videoPlayerWillChangeToOriginalScreenModeBlock)();
/// 将要切换到全屏模式
@property (nonatomic, copy) void(^videoPlayerWillChangeToFullScreenModeBlock)();

- (instancetype)initWithFrame:(CGRect)frame;
/// 展示播放器
- (void)showInView:(UIView *)view;

@end
