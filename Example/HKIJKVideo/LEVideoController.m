//
//  LEVideoController.m
//  HKIJLVideoPlayer_Example
//
//  Created by Lefo on 2019/8/13.
//  Copyright © 2019 lefo720. All rights reserved.
//

#import "LEVideoController.h"
#import "LEAppDelegate.h"
#import "LEPlayerControl.h"

#import "LEPlayerOption.h"
#import "LEVideoController.h"

@interface LEVideoController ()<LEPlayerDelegate>
@property(nonatomic,strong)LEPlayerOption *playerOptions;//存放视频播放器的一些属性
@property(nonatomic,strong)LEPlayerControl *playerControlView;

@end

@implementation LEVideoController


-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
    
    LEAppDelegate *delegate = (LEAppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = NO;
    
    NSNumber * value  = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBarHidden = YES;
    
//    NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
//    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
//
    
    // 倍速及质量
    NSArray *speedList = @[@"1.0",@"1.25",@"1.5",@"2.0"];
    NSMutableArray *speedArray = [NSMutableArray arrayWithCapacity:speedList.count];
    for (int i=0; i<speedList.count; i++) {
        LEVideoStreamModel *model = [LEVideoStreamModel new];
        NSString *value = [speedList objectAtIndex:i];
        model.name = [NSString stringWithFormat:@"%@X",value];
        model.value = value;
        [speedArray addObject:model];
    }
    
    NSArray *videoName = @[@"原画",@"高清",@"标清"];
    NSMutableArray *qualityArray = [NSMutableArray arrayWithCapacity:speedList.count];
    for (int i=0; i<videoName.count; i++) {
        LEVideoStreamModel *model = [LEVideoStreamModel new];
        NSString *value = [speedList objectAtIndex:i];
        model.name = videoName[i];
        model.value = @"";
        [qualityArray addObject:model];
    }
    
    
    // 初始化数据
    self.playerOptions = [[LEPlayerOption alloc]init];
    self.playerOptions.isLiving = false;
    self.playerOptions.speedList = speedArray.copy;
    self.playerOptions.qualityList = qualityArray.copy;
    self.playerOptions.playManager = LEPlayerManagerWithAVPlayer;
    self.playerOptions.isShowAwardView = false;
    
    
    
    [self createPlayerView];
}


#pragma mark - 创建播放器的相关操作
-(void)createPlayerView
{
    LEAppDelegate *delegate = (LEAppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotation = YES;
    NSNumber *value  = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    self.playerControlView = [[LEPlayerControl alloc]initWithFrame:CGRectZero];
    CGRect frame = self.view.bounds;
    self.playerControlView.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
    self.playerControlView.delegate = self;
    self.playerControlView.playerOption = self.playerOptions;
    [self.view addSubview:self.playerControlView];

    // 开始播放
    NSString *remoteUrl = @"http://fastwebcache.yod.cn/yanglan/2013suoluosi/2013suoluosi_850/2013suoluosi_850.m3u8";
    [self.playerControlView playVideo:remoteUrl];
    
   

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.playerControlView setComplishValue:33 achieve:50];
    });
}

- (void)backBtnCLick:(UIButton *)sender{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
