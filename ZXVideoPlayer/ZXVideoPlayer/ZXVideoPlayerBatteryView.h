//
//  ZXVideoPlayerBatteryView.h
//  ZXVideoPlayer
//
//  Created by Shawn on 16/4/23.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kVideoBatteryViewWidth  = 30.0;
static const CGFloat kVideoBatteryViewHeight = 12.0;

@interface ZXVideoPlayerBatteryView : UIView

/// 设备电量
@property (nonatomic, assign, readwrite) CGFloat batteryLevel;

@end
