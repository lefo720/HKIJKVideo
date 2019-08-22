//
//  LEPlayerControl.h
//  FBSnapshotTestCase
//
//  Created by Lefo on 2019/7/20.
//  Copyright © 2019年 Lefo. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "LECoverView.h"
#import "LEPlayerDelegate.h"
@class LEButton;
@class LELoading;
//@class LENetNotiView;
@class LELoadingView;
@class LEPlayerOption;

#define KScreenWidth  [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height

#pragma mark - LEPlayerControl

NS_ASSUME_NONNULL_BEGIN
@interface LEPlayerControl : UIView<LEPlayerDelegate>

@property(nonatomic,strong)id<LEPlayerDelegate> delegate;

//视频占位图
@property(nonatomic,copy)NSString *playerPlaceHolderImgName;

/*
 播放器的一些相关参数
 */
@property(nonatomic,strong)LEPlayerOption *playerOption;

/**
 设置激励体系

 @param goldValue 金币
 @param achieveValue 成就值
 */
- (void)setComplishValue:(NSInteger)goldValue
                 achieve:(NSInteger)achieveValue;

/*
 初始化视频播放器
 */

- (void)playVideo:(NSString *)URLString;

/*
 释放视频播放器
 */
-(void)destoryControl;



NS_ASSUME_NONNULL_END
@end
