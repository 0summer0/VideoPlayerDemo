//
//  ZXVideoPlayerTimeIndicatorView.h
//  ZXVideoPlayer
//
//  Created by Shawn on 16/4/21.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZXTimeIndicatorPlayState) {
    ZXTimeIndicatorPlayStateRewind,      // rewind
    ZXTimeIndicatorPlayStateFastForward, // fast forward
};

static const CGFloat kVideoTimeIndicatorViewSide = 96;

@interface ZXVideoPlayerTimeIndicatorView : UIView

@property (nonatomic, strong, readwrite) NSString *labelText;
@property (nonatomic, assign, readwrite) ZXTimeIndicatorPlayState playState;

@end
