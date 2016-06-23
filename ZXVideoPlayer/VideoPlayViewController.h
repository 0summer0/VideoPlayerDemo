//
//  VideoPlayViewController.h
//  ZXVideoPlayer
//
//  Created by Shawn on 16/4/29.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXVideo;
@interface VideoPlayViewController : UIViewController

@property (nonatomic, strong, readwrite) ZXVideo *video;

@end
