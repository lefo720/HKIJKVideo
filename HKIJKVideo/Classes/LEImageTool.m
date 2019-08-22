//
//  LEImageTool.m
//  FBSnapshotTestCase
//
//  Created by Lefo on 2019/8/13.
//

#import "LEImageTool.h"

@implementation LEImageTool

UIImage * loadImage(NSString *imageName){
    
    NSBundle *currentBundle = [NSBundle mainBundle];
    // 获取屏幕pt和px之间的比例
    NSInteger scale = [UIScreen mainScreen].scale;
    NSString *imagefailName = [NSString stringWithFormat:@"%@@%zdx.png",imageName,scale];
    // 获取图片的路径,其中BMCH5WebView是组件名
    NSString *imagePath = [currentBundle pathForResource:imagefailName ofType:nil inDirectory:[NSString stringWithFormat:@"%@.bundle",@"HKIJKVideo"]];
    // 获取图片
    return [UIImage imageWithContentsOfFile:imagePath];
}


@end
