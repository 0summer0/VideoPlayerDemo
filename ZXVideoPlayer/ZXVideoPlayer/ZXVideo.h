//
//  ZXVideo.h
//  ZXVideoPlayer
//
//  Created by Shawn on 16/6/22.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZXVideo : NSObject

/// 标题
@property (nonatomic, copy, readwrite) NSString *title;
/// 播放地址
@property (nonatomic, copy, readwrite) NSString *playUrl;

@end
