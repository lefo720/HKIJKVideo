//
//  LENetNotiView.h
//  IJKplayerTest
//
//  Created by Lefo on 2019/4/8.
//  Copyright © 2019年 Lefo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LENetNotiViewType ) {
    LENetNotiViewTypeOfNoNetWork   = 0,//没有网络的时候的提示类型
    LENetNotiViewTypeOfBecomeWWAN  = 1,//切换成3G/4G时候的提示类型
};
typedef void(^SelectBtnClickBlock)();
typedef void(^backbtnCLickBlock)();
@interface LENetNotiView : UIView
/*
 背景View
 */
@property(nonatomic,strong)UIView *bgView;

/*
 上方的提示文字
 */
@property(nonatomic,strong)UILabel *showLabel;

/*
 下面的选择按钮
 */
@property(nonatomic,strong)UIButton *selectBtn;

/*
 提示类型
 */
@property (nonatomic, assign) LENetNotiViewType netWorkNotiViewType;

/*
 提示界面的返回按钮
 */
@property(nonatomic,strong)UIButton *backBtn;
/*
 点击按钮的回调方法
 */
@property(nonatomic,copy)SelectBtnClickBlock btnClickblock;
/*
 点击返回按钮的回调方法
 */
@property(nonatomic,copy)backbtnCLickBlock backBlock;
/*
 显示并且设定显示的类型
 */
-(void)showNetNotiViewWithType:(LENetNotiViewType)type;

/*
 隐藏提示框
 */
-(void)hideNetNotiView;

@end
