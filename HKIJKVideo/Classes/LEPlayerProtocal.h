//
//  LEPlayerProtocal.h
//  FBSnapshotTestCase
//
//  Created by Lefo on 2019/8/19.
//  Copyright © 2019年 Lefo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEVideoDefine.h"

// 注:protocol中声明的属性需要 在实现中添加@synthesize生成别名
NS_ASSUME_NONNULL_BEGIN

@protocol LEPlayerProtocal <NSObject>

@optional
// 初始回调
//@property(nonatomic, copy) void (^initVideoBlock)(id player);

// 监听加载状态
@property(nonatomic, copy) void (^videoLoadStateBlock)(LEVideoLoadState state);

// 视频结束状态
@property(nonatomic, copy) void (^videoFinishBlock)(LEVideoFinishState state);

// 视频播放状态
@property(nonatomic, copy) void (^videoPlayStateBlock)(LEPlaybackState status);

// 视频准备播放
@property(nonatomic, copy) void (^videoPreparePlayBlock)();


- (void)desctoryManager;

- (void)play;

- (void)pause;

- (void)stop;

- (void)prepareToPlay;

- (id)get_playerView;

@optional
- (NSTimeInterval)get_duration;
- (NSTimeInterval)get_currentPlaybackTime;
- (NSTimeInterval)get_playableDuration;
- (BOOL)get_playState;
-(void)set_currentPlaybackTime:(NSTimeInterval)time;

- (void)set_playRate:(float)rate;

@end

NS_ASSUME_NONNULL_END
