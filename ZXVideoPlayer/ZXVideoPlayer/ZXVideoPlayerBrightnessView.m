//
//  ZXVideoPlayerBrightnessView.m
//  ZXVideoPlayer
//
//  Created by Shawn on 16/4/21.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "ZXVideoPlayerBrightnessView.h"
#import "ZXVideoPlayerControlView.h"

static const CGFloat kViewSpacing = 21.0;
static const CGFloat kBrightnessIndicatorAutoFadeOutTimeInterval = 1.0;

@interface ZXVideoPlayerBrightnessView ()

@property (nonatomic, strong) NSMutableArray *blocksArray;

@end

@implementation ZXVideoPlayerBrightnessView

- (void)dealloc
{
    [[UIScreen mainScreen] removeObserver:self forKeyPath:@"brightness"];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        [self createBrightnessIndicator];
        [self configScreenBrightnessObserver];
    }
    return self;
}

- (void)configScreenBrightnessObserver
{
    [[UIScreen mainScreen] addObserver:self
                            forKeyPath:@"brightness"
                               options:NSKeyValueObservingOptionNew
                               context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    CGFloat brightness = [change[@"new"] floatValue];
    [self updateBrightnessIndicator:brightness];
}

- (void)createBrightnessIndicator
{
    // 亮度图标
    UIImageView *brightnessImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kVideoBrightnessIndicatorViewSide - 50) / 2, kViewSpacing, 50, 50)];
    [brightnessImageView setImage:[UIImage imageNamed:@"zx-video-player-brightness"]];
    [self addSubview:brightnessImageView];
    
    // 亮度条
    self.blocksArray = [NSMutableArray arrayWithCapacity:16];
    
    UIView *blockBackgroundView = [[UIView alloc] initWithFrame:CGRectMake((kVideoVolumeIndicatorViewSide - 105) / 2, 50 + kViewSpacing * 2, 105, 2.75 + 2)];
    blockBackgroundView.backgroundColor = [UIColor colorWithRed:0.25f green:0.22f blue:0.21f alpha:0.65];
    [self addSubview:blockBackgroundView];
    
    CGFloat margin = 1;
    CGFloat blockW = 5.5;
    CGFloat blockH = 2.75;
    
    for (int i = 0; i < 16; i++) {
        CGFloat locX = i * (blockW + margin) + margin;
        UIImageView *blockView = [[UIImageView alloc] init];
        blockView.backgroundColor = [UIColor whiteColor];
        blockView.frame = CGRectMake(locX, margin, blockW, blockH);
        
        [blockBackgroundView addSubview:blockView];
        [self.blocksArray addObject:blockView];
    }
}

- (void)updateBrightnessIndicator:(CGFloat)value
{
    self.hidden = NO;
    
    // 防止重叠显示
    if (self.superview.accessibilityIdentifier) {
        ZXVideoPlayerControlView *playerView = (ZXVideoPlayerControlView *)self.superview;
        playerView.timeIndicatorView.hidden = YES;
        playerView.volumeIndicatorView.hidden = YES;
    } else {
        self.superview.accessibilityIdentifier = @"";
    }
    
    CGFloat stage = 1 / 16.0;
    NSInteger level = value / stage;
    
    for (NSInteger i=0; i<self.blocksArray.count; i++) {
        UIImageView *img = self.blocksArray[i];
        
        if (i <= level) {
            img.hidden = NO;
        } else {
            img.hidden = YES;
        }
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:kBrightnessIndicatorAutoFadeOutTimeInterval];
}

- (void)animateHide
{
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.alpha = 1;
        self.superview.accessibilityIdentifier = nil;
    }];
}

@end
