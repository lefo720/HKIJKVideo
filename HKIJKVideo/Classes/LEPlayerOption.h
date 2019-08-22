//
//  LEPlayerOption.h
//  FBSnapshotTestCase
//
//  Created by Lefo on 2019/7/19.
//  Copyright © 2019年 Lefo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEVideoDefine.h"
@class LEVideoStreamModel;

@interface LEPlayerOption : NSObject


/**
  目前支持两种播放管理器1.LEIJKVideoManager 2.LEAVPlayerManager
  如果没有, 默认使用2
 */
@property(nonatomic, assign) LEPlayerManager playManager;

/**
 是否是直播
 */
@property(nonatomic, assign) BOOL isLiving;

/*
 是否是正在播放状态
 */
@property(nonatomic,assign)BOOL isPlaying;

/**
 是否显示奖励体系
 */
@property(nonatomic, assign) BOOL isShowAwardView;

/*
 当前播放时间
 */
@property(nonatomic,assign) NSTimeInterval currenTime;

/*
 视频的总时长
 */
@property(nonatomic,assign) NSTimeInterval totalTime;

/**
 清晰度显示列表
 */
@property(nonatomic,copy) NSArray<LEVideoStreamModel *> *qualityList;

/**
 倍速显示列表
 */
@property(nonatomic,copy) NSArray<LEVideoStreamModel *> *speedList;


/**
 视频名称
 */
@property(nonatomic, copy) NSString *videoName;


/**
 激励体系-金币
 */
@property(nonatomic, assign) NSInteger goldValue;

/**
 激励体系-成长值
 */
@property(nonatomic, assign) NSInteger achieveValue;

@end


@interface LEVideoStreamModel : NSObject

@property(nonatomic, copy) NSString *name;

@property(nonatomic, copy) NSString *value;

@end
