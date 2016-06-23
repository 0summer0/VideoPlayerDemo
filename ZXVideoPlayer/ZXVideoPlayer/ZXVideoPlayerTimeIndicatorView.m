//
//  ZXVideoPlayerTimeIndicatorView.m
//  ZXVideoPlayer
//
//  Created by Shawn on 16/4/21.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "ZXVideoPlayerTimeIndicatorView.h"
#import "ZXVideoPlayerControlView.h"

static const CGFloat kViewSpacing = 15.0;
static const CGFloat kTimeIndicatorAutoFadeOutTimeInterval = 1.0;

@interface ZXVideoPlayerTimeIndicatorView ()

@property (nonatomic, strong, readwrite) UIImageView *arrowImageView;
@property (nonatomic, strong, readwrite) UILabel     *timeLabel;

@end

@implementation ZXVideoPlayerTimeIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        [self createTimeIndicator];
    }
    return self;
}

- (void)setLabelText:(NSString *)labelText
{
    //    _labelText = [labelText copy];
    self.hidden = NO;
    self.timeLabel.text = labelText;
    
    // 防止重叠显示
    if (self.superview.accessibilityIdentifier) {
        ZXVideoPlayerControlView *playerView = (ZXVideoPlayerControlView *)self.superview;
        playerView.brightnessIndicatorView.hidden = YES;
        playerView.volumeIndicatorView.hidden = YES;
    } else {
        self.superview.accessibilityIdentifier = @"";
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:kTimeIndicatorAutoFadeOutTimeInterval];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.playState == ZXTimeIndicatorPlayStateRewind) {
        [self.arrowImageView setImage:[UIImage imageNamed:@"zx-video-player-rewind"]];
    } else {
        [self.arrowImageView setImage:[UIImage imageNamed:@"zx-video-player-fastForward"]];
    }
}

- (void)createTimeIndicator
{
    CGFloat margin = (kVideoTimeIndicatorViewSide - 24 - 12 - kViewSpacing) / 2;
    _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kVideoTimeIndicatorViewSide - 44) / 2, margin, 44, 24)];
    [self addSubview:_arrowImageView];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, margin + 24 + kViewSpacing, kVideoTimeIndicatorViewSide, 12)];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_timeLabel];
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
