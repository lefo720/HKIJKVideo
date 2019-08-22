//
//  LESettingTableView.h
//  FBSnapshotTestCase
//
//  Created by Lefo on 2019/7/30.
//  Copyright © 2019年 Lefo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@protocol LESettingTableDelegate;

@interface LESettingTableView : UIView


@property(nonatomic, strong) NSArray<NSString *> * dataArray;

@property(nonatomic, weak) id<LESettingTableDelegate> delegate;

@end

@protocol LESettingTableDelegate <NSObject>

- (void)settingView:(LESettingTableView *)view didSelected:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
