//
//  LEAppDelegate.h
//  HKIJLVideoPlayer
//
//  Created by lefo720 on 08/07/2019.
//  Copyright (c) 2019 lefo720. All rights reserved.
//

@import UIKit;

@interface LEAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/*
 决定是不是可以允许转屏的参数
 */
@property(nonatomic,assign)NSInteger allowRotation;

@end
