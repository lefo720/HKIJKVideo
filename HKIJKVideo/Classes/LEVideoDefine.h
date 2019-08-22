//
//  LEVideoDefine.h
//  FBSnapshotTestCase
//
//  Created by Lefo on 2019/8/20.
//  Copyright © 2019年 Lefo. All rights reserved.
//

#ifndef LEVideoDefine_h
#define LEVideoDefine_h

// 加载状态
typedef NS_OPTIONS(NSUInteger, LEVideoLoadState) {
    LEVideoLoadStateUnknown        = 0, // 未知状态
    LEVideoLoadStatePlayable       = 1 << 0, // 缓存数据足够开始播放
    LEVideoLoadStatePlaythroughOK  = 1 << 1, // 缓冲完成, 自动播放(设置自动播放后)
    LEVideoLoadStateStalled        = 1 << 2 // 正在缓冲中:可以在这个状态下加入加载视图，缓冲动画等
};

typedef NS_ENUM(NSInteger, LEVideoFinishState) {
    LEVideoFinishStateWithEnded, // 播放结束
    LEVideoFinishStateWithError, // 播放错误
    LEVideoFinishStateWithUserExited // 用户退出
};

typedef NS_ENUM(NSInteger, LEPlaybackState) {
    LEPlaybackStateStopped,
    LEPlaybackStatePlaying,
    LEPlaybackStatePaused,
    LEPlaybackStateInterrupted,
    LEPlaybackStateSeekingForward,
    LEPlaybackStateSeekingBackward
};


typedef NS_OPTIONS(NSInteger, LEPlayerManager) {
    LEPlayerManagerWithAVPlayer,
    LEPlayerManagerWithIJKVideo
};

static inline NSString * NSStringFromTransactionState(LEPlayerManager state) {
    switch (state) {
        case LEPlayerManagerWithAVPlayer:
            return @"LEAVPlayerManager";
        case LEPlayerManagerWithIJKVideo:
            return @"LEIJKVideoManager";
        default:
            return @"LEAVPlayerManager";
    }
}

#endif /* LEVideoDefine_h */
