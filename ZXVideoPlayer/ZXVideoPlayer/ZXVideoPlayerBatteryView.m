//
//  ZXVideoPlayerBatteryView.m
//  ZXVideoPlayer
//
//  Created by Shawn on 16/4/23.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "ZXVideoPlayerBatteryView.h"

@implementation ZXVideoPlayerBatteryView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setInitialBatteryLevel];
        [self addBatteryObserver];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat borderWidth = 1.0; // 边框线宽
    CGFloat margin      = 1.0; // 电量填充rect距边框的距离
    CGFloat blockWidth  = 2.0;
    CGFloat blockHeight = 6.0;
    
    [[UIColor whiteColor] set];
    
    // 电池矩形框(self内边缘绘制边框)
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(borderWidth / 2, borderWidth / 2, CGRectGetWidth(self.bounds) - borderWidth - blockWidth, CGRectGetHeight(self.bounds) - borderWidth) cornerRadius:3];
    borderPath.lineWidth = borderWidth;
    [borderPath stroke];
    
    // 电池正极 (只有 topRight && bottomRight 两个角有圆角)
    UIBezierPath *blockPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(CGRectGetMaxX(borderPath.bounds) + borderWidth / 2, CGRectGetMidY(borderPath.bounds) - blockHeight / 2, blockWidth, blockHeight) byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(blockWidth / 2, blockHeight / 2)];
    blockPath.lineWidth = 0.01;
    [blockPath fill];
    [blockPath stroke];
    
    // 填充电量 (距离边框保留magin单位宽度)
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(borderWidth + margin, borderWidth + margin, ((CGRectGetWidth(borderPath.bounds) - borderWidth - margin) - margin) * self.batteryLevel, CGRectGetHeight(self.bounds) - (borderWidth + margin) * 2));
}

- (void)setInitialBatteryLevel
{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    self.batteryLevel = [UIDevice currentDevice].batteryLevel;
}

- (void)addBatteryObserver
{
    // or use [[UIDevice currentDevice] addObserver:self forKeyPath:@"batteryLevel" options:NSKeyValueObservingOptionNew context:NULL];
    //  以上方法调用次数相对较多，所以修改为仅当值改变时重绘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBatteryLevelChanged:) name:UIDeviceBatteryLevelDidChangeNotification object:nil];
}

- (void)onBatteryLevelChanged:(NSNotification *)noti
{
    self.batteryLevel = ((UIDevice *)noti.object).batteryLevel;
    [self setNeedsDisplay]; // redrawn battery view
}

@end
