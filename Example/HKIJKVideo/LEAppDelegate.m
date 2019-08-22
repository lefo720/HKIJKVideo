//
//  LEAppDelegate.m
//  HKIJLVideoPlayer
//
//  Created by lefo720 on 08/07/2019.
//  Copyright (c) 2019 lefo720. All rights reserved.
//

#import "LEAppDelegate.h"

@implementation LEAppDelegate
#pragma mark - 屏幕旋转相关设置
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    
    if (self.allowRotation == 0) {      //当允许时，支持竖屏
        return  UIInterfaceOrientationMaskPortrait ;
    }else if (self.allowRotation == 1) {//当允许时，支持横屏幕
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    //当允许时，支持所有方向
    return UIInterfaceOrientationMaskAll;
    
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
