//
//  ZXVideoPlayerControlView.m
//  ZXVideoPlayer
//
//  Created by Shawn on 16/4/21.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "ZXVideoPlayerControlView.h"

static const CGFloat kVideoControlBarHeight = 20.0 + 30.0;
static const CGFloat kVideoControlAnimationTimeInterval = 0.3;
static const CGFloat kVideoControlTimeLabelFontSize = 10.0;
static const CGFloat kVideoControlBarAutoFadeOutTimeInterval = 5.0;

@interface ZXVideoPlayerControlView ()

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, strong) UIButton *shrinkScreenButton;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) BOOL isBarShowing;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation ZXVideoPlayerControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.topBar];
        [self addSubview:self.bottomBar];
        [self.bottomBar addSubview:self.playButton];
        [self.bottomBar addSubview:self.pauseButton];
        self.pauseButton.hidden = YES;
        [self.bottomBar addSubview:self.fullScreenButton];
        [self.bottomBar addSubview:self.shrinkScreenButton];
        self.shrinkScreenButton.hidden = YES;
        [self.bottomBar addSubview:self.progressSlider];
        [self.bottomBar addSubview:self.timeLabel];
        [self addSubview:self.indicatorView];
        
        // 返回按钮
        [self.topBar addSubview:self.backButton];
        // 锁定按钮
        [self.topBar addSubview:self.lockButton];
        // 缓冲进度条
        [self.bottomBar insertSubview:self.bufferProgressView belowSubview:self.progressSlider];
        // 快进、快退指示器
        [self addSubview:self.timeIndicatorView];
        // 亮度指示器
        [self addSubview:self.brightnessIndicatorView];
        // 音量指示器
        [self addSubview:self.volumeIndicatorView];
        // 电池条
//        [self.topBar addSubview:self.batteryView];
        // 标题
        [self.topBar addSubview:self.titleLabel];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tapGesture];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.topBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), CGRectGetWidth(self.bounds), kVideoControlBarHeight);
    
    self.bottomBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetHeight(self.bounds) - kVideoControlBarHeight, CGRectGetWidth(self.bounds), kVideoControlBarHeight);
    
    self.playButton.frame = CGRectMake(CGRectGetMinX(self.bottomBar.bounds), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.playButton.bounds)/2, CGRectGetWidth(self.playButton.bounds), CGRectGetHeight(self.playButton.bounds));
    
    self.pauseButton.frame = self.playButton.frame;
    
    self.fullScreenButton.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - CGRectGetWidth(self.fullScreenButton.bounds), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.fullScreenButton.bounds)/2, CGRectGetWidth(self.fullScreenButton.bounds), CGRectGetHeight(self.fullScreenButton.bounds));
    
    self.shrinkScreenButton.frame = self.fullScreenButton.frame;
    
    self.progressSlider.frame = CGRectMake(CGRectGetMaxX(self.playButton.frame), 0, CGRectGetMinX(self.fullScreenButton.frame) - CGRectGetMaxX(self.playButton.frame), kVideoControlBarHeight);
    
    self.timeLabel.frame = CGRectMake(CGRectGetMidX(self.progressSlider.frame), CGRectGetHeight(self.bottomBar.bounds) - CGRectGetHeight(self.timeLabel.bounds) - 2.0, CGRectGetWidth(self.progressSlider.bounds)/2, CGRectGetHeight(self.timeLabel.bounds));
    
    self.indicatorView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    // 返回按钮
    self.backButton.frame = CGRectMake(CGRectGetMinX(self.topBar.bounds), CGRectGetHeight(self.topBar.bounds) - 40, 40, 40);
    // 锁定按钮
    self.lockButton.frame = CGRectMake(CGRectGetMaxX(self.topBar.bounds) - 40 - 10, CGRectGetHeight(self.topBar.bounds) - 40, 40, 40);
    // 缓冲进度条
    self.bufferProgressView.bounds = CGRectMake(0, 0, self.progressSlider.bounds.size.width - 7, self.progressSlider.bounds.size.height);
    self.bufferProgressView.center = CGPointMake(self.progressSlider.center.x + 2, self.progressSlider.center.y);
    // 快进、快退指示器
    self.timeIndicatorView.center = self.indicatorView.center;
    // 亮度指示器
    self.brightnessIndicatorView.center = self.indicatorView.center;
    // 音量指示器
    self.volumeIndicatorView.center = self.indicatorView.center;
    // 电池条
//    self.batteryView.frame = CGRectMake(CGRectGetMinX(self.lockButton.frame) - CGRectGetWidth(self.batteryView.bounds) - 10, CGRectGetMidY(self.topBar.bounds) - CGRectGetHeight(self.batteryView.bounds) / 2, CGRectGetWidth(self.batteryView.bounds), CGRectGetHeight(self.batteryView.bounds));
    // 标题
    self.titleLabel.frame = CGRectMake(CGRectGetWidth(self.backButton.bounds), 20, CGRectGetWidth(self.topBar.bounds) - CGRectGetWidth(self.backButton.bounds) - CGRectGetWidth(self.lockButton.bounds), kVideoControlBarHeight - 20);
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.isBarShowing = YES;
}

#pragma mark - Public Method

- (void)animateHide
{
    if (!self.isBarShowing) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kZXPlayerControlViewHideNotification object:nil];
    
    [UIView animateWithDuration:kVideoControlAnimationTimeInterval animations:^{
        self.topBar.alpha = 0.0;
        self.bottomBar.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.isBarShowing = NO;
    }];
}

- (void)animateShow
{
    if (self.isBarShowing) {
        return;
    }
    [UIView animateWithDuration:kVideoControlAnimationTimeInterval animations:^{
        self.topBar.alpha = 1.0;
        self.bottomBar.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.isBarShowing = YES;
        [self autoFadeOutControlBar];
    }];
}

- (void)autoFadeOutControlBar
{
    if (!self.isBarShowing) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:kVideoControlBarAutoFadeOutTimeInterval];
}

- (void)cancelAutoFadeOutControlBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
}

#pragma mark - Tap Detection

- (void)onTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (self.isBarShowing) {
            [self animateHide];
        } else {
            [self animateShow];
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        }
    }
}

#pragma mark - getters

- (UIView *)topBar
{
    if (!_topBar) {
        _topBar = [UIView new];
        _topBar.accessibilityIdentifier = @"TopBar";
        _topBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _topBar;
}

- (UIView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [UIView new];
        _bottomBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return _bottomBar;
}

- (UIButton *)playButton
{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"kr-video-player-play"] forState:UIControlStateNormal];
        _playButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _playButton;
}

- (UIButton *)pauseButton
{
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton setImage:[UIImage imageNamed:@"kr-video-player-pause"] forState:UIControlStateNormal];
        _pauseButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _pauseButton;
}

- (UIButton *)fullScreenButton
{
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:@"kr-video-player-fullscreen"] forState:UIControlStateNormal];
        _fullScreenButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _fullScreenButton;
}

- (UIButton *)shrinkScreenButton
{
    if (!_shrinkScreenButton) {
        _shrinkScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shrinkScreenButton setImage:[UIImage imageNamed:@"kr-video-player-shrinkscreen"] forState:UIControlStateNormal];
        _shrinkScreenButton.bounds = CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight);
    }
    return _shrinkScreenButton;
}

- (UISlider *)progressSlider
{
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] init];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"kr-video-player-point"] forState:UIControlStateNormal];
        [_progressSlider setMinimumTrackTintColor:[UIColor whiteColor]];
        [_progressSlider setMaximumTrackTintColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.4]];
        _progressSlider.value = 0.f;
        _progressSlider.continuous = YES;
    }
    return _progressSlider;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:kVideoControlTimeLabelFontSize];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.bounds = CGRectMake(0, 0, kVideoControlTimeLabelFontSize, kVideoControlTimeLabelFontSize);
    }
    return _timeLabel;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_indicatorView stopAnimating];
    }
    return _indicatorView;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kVideoControlBarHeight , kVideoControlBarHeight)];
        [_backButton setImage:[UIImage imageNamed:@"zx-video-banner-back"] forState:UIControlStateNormal];
        _backButton.contentEdgeInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    }
    return _backButton;
}

- (UIButton *)lockButton
{
    if (!_lockButton) {
        _lockButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, kVideoControlBarHeight, kVideoControlBarHeight)];
        [_lockButton setImage:[UIImage imageNamed:@"zx-video-player-unlock"] forState:UIControlStateNormal];
        [_lockButton setImage:[UIImage imageNamed:@"zx-video-player-lock"] forState:UIControlStateHighlighted];
        [_lockButton setImage:[UIImage imageNamed:@"zx-video-player-lock"] forState:UIControlStateSelected];
        _lockButton.contentEdgeInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }
    return _lockButton;
}

- (UIProgressView *)bufferProgressView
{
    if (!_bufferProgressView) {
        _bufferProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _bufferProgressView.progressTintColor = [UIColor colorWithWhite:1 alpha:0.3];
        _bufferProgressView.trackTintColor = [UIColor clearColor];
    }
    return _bufferProgressView;
}

- (ZXVideoPlayerTimeIndicatorView *)timeIndicatorView
{
    if (!_timeIndicatorView) {
        _timeIndicatorView = [[ZXVideoPlayerTimeIndicatorView alloc] initWithFrame:CGRectMake(0, 0, kVideoTimeIndicatorViewSide, kVideoTimeIndicatorViewSide)];
    }
    return _timeIndicatorView;
}

- (ZXVideoPlayerBrightnessView *)brightnessIndicatorView
{
    if (!_brightnessIndicatorView) {
        _brightnessIndicatorView = [[ZXVideoPlayerBrightnessView alloc] initWithFrame:CGRectMake(0, 0, kVideoBrightnessIndicatorViewSide, kVideoBrightnessIndicatorViewSide)];
    }
    return _brightnessIndicatorView;
}

- (ZXVideoPlayerVolumeView *)volumeIndicatorView
{
    if (!_volumeIndicatorView) {
        _volumeIndicatorView = [[ZXVideoPlayerVolumeView alloc] initWithFrame:CGRectMake(0, 0, kVideoVolumeIndicatorViewSide, kVideoVolumeIndicatorViewSide)];
    }
    return _volumeIndicatorView;
}

- (ZXVideoPlayerBatteryView *)batteryView
{
    if (!_batteryView) {
        _batteryView = [[ZXVideoPlayerBatteryView alloc] initWithFrame:CGRectMake(0, 0, kVideoBatteryViewWidth, kVideoBatteryViewHeight)];
    }
    return _batteryView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
