//
//  LEPlayerDelegate.h
//  FBSnapshotTestCase
//
//  Created by Lefo on 2019/8/19.
//  Copyright © 2019年 Lefo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEVideoDefine.h"
@class LEPlayerControl;

NS_ASSUME_NONNULL_BEGIN
@protocol LEPlayerDelegate <NSObject>

/**
 视频缓冲状态

 @param state 加载状态
 */
- (void)le_playerControl:(LEPlayerControl *)control videoLoadState:(LEVideoLoadState)state;

/*
 播放完毕
 @param state 状态
 */
- (void)le_playerControl:(LEPlayerControl *)control videoPlayFinish:(LEVideoFinishState)state;


/*
 当前播放状态
 @param state 播放状态
 */
- (void)le_playerControl:(LEPlayerControl *)control videoPlayBackState:(LEPlaybackState)playState;


/*
 返回按钮点击方法
 */
-(void)backBtnCLick:(UIButton *_Nullable)sender;



@end
NS_ASSUME_NONNULL_END
