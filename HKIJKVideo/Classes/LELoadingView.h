//
//  LELoadingView.h
//  IJKplayerTest
//
//  Created by Lefo on 2019/4/9.
//  Copyright © 2019年 Lefo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LELoadingView : UIView
/*
 显示加载框并且显示加载动画
 */
-(void)showAndStartAnimation;
/*
 隐藏加载框并且停止加载动画
 */
-(void)hideAndStopAnimation;

@end
