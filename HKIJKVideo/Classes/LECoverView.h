//
//  LECoverView.h
//  FBSnapshotTestCase
//
//  Created by Lefo on 2019/7/29.
//  Copyright © 2019年 Lefo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEButton.h"
#import "LEMarqueeLabel.h"

typedef enum : NSUInteger {
    VideoStreamPannelWithSpeed, // 速率
    VideoStreamPannelWithQuality,// 画质
} VideoStreamPannel;

NS_ASSUME_NONNULL_BEGIN

@interface LECoverView : UIView
// 视频标题
@property(nonatomic, copy) NSString *videoName;
// 激励体系-金币
@property(nonatomic, assign) NSInteger goldValue;
// 激励体系-成长值
@property(nonatomic, assign) NSInteger achieveValue;
//倍速列表
@property(nonatomic, copy) NSArray *speedList;
//视频质量
@property(nonatomic, copy) NSArray *qualityList;
// 播放按钮
@property(nonatomic, strong) LEButton *playBtn;
// 当前时间
@property(nonatomic, strong) UILabel *lblCurrentTime;
// 总时长
@property(nonatomic, strong) UILabel *lblTotalTime;

// 进度条
@property(nonatomic, strong) UIProgressView *progressView;
// 滑块
@property(nonatomic, strong) UISlider *sliderView;

// 隐藏设置页
@property(nonatomic, assign) BOOL hiddenSettingView;
//倍速及质量类型
@property(nonatomic, assign) VideoStreamPannel videoStream;

// 全屏回调
@property(nonatomic, copy) void (^fullBtnActionBlock)(UIButton *sender);

// 返回
@property(nonatomic, copy) void (^returnBackBlock)(UIButton *sender);
// 滑块回调
@property(nonatomic, copy) void (^sliderEventBlock)(UISlider *slider);
// 播放按钮回调
@property(nonatomic, copy) void (^playActionBlock)(BOOL isSelected);

@property(nonatomic, copy) void (^swithVideoBlock)(VideoStreamPannel videoStream, NSInteger row);

- (void)showArchieveView:(BOOL)isShow;

- (void)showLivingView:(BOOL)isLiving;

@end

NS_ASSUME_NONNULL_END
