//
//  LEMarqueeLabel.h
//  PlayerView
//
//  Created by Lefo on 2018/11/12.
//  Copyright © 2018 Lefo. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, HKMarqueeLabelType) {
    HKMarqueeLabelTypeLeft = 0,//向左边滚动
    HKMarqueeLabelTypeLeftRight = 1,//先向左边，再向右边滚动
};

NS_ASSUME_NONNULL_BEGIN

@interface LEMarqueeLabel : UILabel
@property(nonatomic,unsafe_unretained)HKMarqueeLabelType marqueeLabelType;
@property(nonatomic,unsafe_unretained)CGFloat speed;//速度
@property(nonatomic,unsafe_unretained)CGFloat secondLabelInterval;
@property(nonatomic,unsafe_unretained)NSTimeInterval stopTime;//滚到顶的停止时间

@end

NS_ASSUME_NONNULL_END
#import <UIKit/UIKit.h>
