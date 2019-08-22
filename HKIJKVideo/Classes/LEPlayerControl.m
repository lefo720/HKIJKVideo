//
//  LEPlayerControl.m
//  FBSnapshotTestCase
//
//  Created by Lefo on 2019/7/20.
//  Copyright © 2019年 Lefo. All rights reserved.
//

#import "LEPlayerControl.h"
#import "LEButton.h"
#import "Masonry.h"
#import "LENetNotiView.h"
#import "LELoadingView.h"
#import "LEPlayerOption.h"
#import "Reachability.h"
#import "LEImageTool.h"
#import "LEPlayerProtocal.h"
@interface LEPlayerControl()<UIGestureRecognizerDelegate,UIApplicationDelegate>

@property(nonatomic,strong)UIView *playerView;//播放器所在的View
@property(nonatomic,strong)UIImageView *voiceImgView;//声音提示图片
@property(nonatomic,strong)UIImageView *brightNessImgView;//亮度提示图片
@property(nonatomic,assign) BOOL isHideTool;//需要隐藏工具栏界面
@property(nonatomic,assign)CGPoint  startPoint;//开始的点
@property(nonatomic,strong)CAShapeLayer *layerView;//layer层动画界面
@property(nonatomic,strong)CAShapeLayer *layerContainer;//
@property(nonatomic,strong)UITapGestureRecognizer *tapGesture;//手势

@property(nonatomic, strong) id<LEPlayerProtocal> manager;

// 音量控制
@property (strong, nonatomic) MPVolumeView *volumeView;//控制音量的view
@property (strong, nonatomic) UISlider *volumeViewSlider;//控制音量
@property(nonatomic, assign) float startVB;
/*
 播放器的远程播放URL
 */
@property(nonatomic,copy)NSString *url;


//player视图的基视图
@property(nonatomic,strong)UIView *playerBaseView;

// IJKplayer播放器
//@property(nonatomic,strong)IJKFFMoviePlayerController *player;


// 网络切换的时候需要显示的提示界面
@property(nonatomic,strong)LENetNotiView *netShowView;


// 蒙版,上面放一些时间label，播放按钮之类的
@property(nonatomic,strong)LECoverView *coverView;

// 播放器加载界面
@property(nonatomic,strong)LELoadingView *loadingView;

/*
 定时器
 */
@property(nonatomic,strong)NSTimer *timer;
/*
 占位图片
 */
@property(nonatomic,strong)UIImageView *playerPlaceHolderImg;//刚开始播放视频的时候占位图片


@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@end

@implementation LEPlayerControl


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        
        [self licenceNetwork];
        
        // 展示层
        [self createCoverView];
        // 加载框
        [self showLoadingView];
        // 音量
        self.volumeView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height * 9.0 / 16.0);
        
        // 设置当前时间
        NSString *currentFormat = [self TimeformatFromSeconds:self.playerOption.currenTime];;
        NSString *currentTime = self.playerOption.currenTime > 0 ? currentFormat : @"00:00:00";
        self.coverView.lblCurrentTime.text = currentTime;
        
        
        // 设置总时长
        NSString *totalFormat = [self TimeformatFromSeconds:self.playerOption.totalTime];
        NSString *totalTime = self.playerOption.currenTime > 0 ? totalFormat : @"00:00:00";
        self.coverView.lblTotalTime.text = totalTime;
        
        // 设置滑块数据
        if ((self.playerOption.currenTime > 0.00) && (self.playerOption.totalTime > 0.00)) {
            [self.coverView.sliderView setValue:self.playerOption.currenTime/self.playerOption.totalTime animated:NO];
        }
        
        // 滑块点击事件
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sliderTap:)];
        [self.coverView.sliderView addGestureRecognizer:_tapGesture];
    
    }
    return self;
}

- (void)playVideo:(NSString *)URLString{
    self.url = URLString;
   
    
    
    
    // 初始化播放器
    BOOL success = [self initIJKPlayerControl:URLString];
    if (success) {
        // 直播 OR 回放
        BOOL isLive = self.playerOption.isLiving;
        [self.coverView showLivingView:isLive];
        // 是否显示激励体系
        [self.coverView showArchieveView:self.playerOption.isShowAwardView];
        // 视频质量 and 倍速
        self.coverView.speedList = [self.playerOption.speedList valueForKey:@"_name"];
        self.coverView.qualityList = [self.playerOption.qualityList valueForKey:@"_name"];
        
        // 播放背景
//        if (self.playerPlaceHolderImgName != nil) {
//            [self.playerView addSubview:self.playerPlaceHolderImg];
//            [self.playerPlaceHolderImg mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.top.bottom.equalTo(self.playerBaseView);
//            }];
//        }
    }
}

- (void)setComplishValue:(NSInteger)goldValue
                 achieve:(NSInteger)achieveValue{
    // 记录最新数据
    self.playerOption.goldValue = goldValue;
    self.playerOption.achieveValue = achieveValue;
    
    // 渲染UI
    self.coverView.goldValue = goldValue;
    self.coverView.achieveValue = achieveValue;
}


- (void)setPlayerOption:(LEPlayerOption *)playerOption{
    if (!_playerOption) {
        _playerOption = [[LEPlayerOption alloc]init];
    }
    _playerOption = playerOption;
}


#pragma mark - 初始化IJK播放器

- (BOOL)initIJKPlayerControl:(NSString *)URLString
{
    
    NSString *managerName = NSStringFromTransactionState(self.playerOption.playManager);
    
    Class clas = NSClassFromString(managerName);
    if (clas == nil) {
        return false;
    }
    NSURL *playUrl = [NSURL URLWithString:URLString];
    self.manager = [[clas alloc] initWithURL:playUrl];
    NSLog(@"%@",URLString);
    
    if (self.playerOption.playManager == LEPlayerManagerWithAVPlayer) {
        self.playerView = [[UIView alloc]init];
        CALayer *playLayer = [self.manager get_playerView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            playLayer.frame = self.playerView.bounds;
            [self.playerBaseView bringSubviewToFront:self.coverView];
        });
        [self.playerView.layer addSublayer:playLayer];
    }else{
        self.playerView = [self.manager get_playerView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self prepareToPlay];
        });
        
    }
    [self.playerBaseView insertSubview:self.playerView atIndex:1];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.playerBaseView);
    }];
    
    [self scriptPlayerReceipt];
    return true;
}

- (void)scriptPlayerReceipt{
    __weak typeof(self) weakSelf = self;
    // 返回的缓冲的状态 可以在这个状态下加入加载视图，缓冲动画等
    self.manager.videoLoadStateBlock = ^(LEVideoLoadState state) {
        switch (state) {
            case LEVideoLoadStatePlaythroughOK:
            {
            }
                break;
                
            case LEVideoLoadStatePlayable:
            {
            }
                break;
                
            case LEVideoLoadStateStalled:
            {
                [weakSelf showLoadingView];
            }
                break;
                
            default:
                
                break;
        }
        /**
         if (self.delegate &&[self.delegate respondsToSelector:@selector(le_playerControl:videoLoadState:)]) {
         [self.delegate le_playerControl:self videoLoadState:state];
         }*/
    };
    // 准备完毕开始播放的时候
    self.manager.videoPreparePlayBlock = ^{
        [weakSelf play];
        [weakSelf.timer fire];
        
        weakSelf.coverView.lblTotalTime.text = [NSString stringWithFormat:@"%@",[weakSelf TimeformatFromSeconds:[weakSelf.manager get_duration]]];
        [weakSelf removeLoadingView];
        [weakSelf.netShowView removeFromSuperview];
        if (weakSelf.playerPlaceHolderImg) {
            [weakSelf.playerPlaceHolderImg removeFromSuperview];
        }
    };
    
    // 播放结束
    self.manager.videoFinishBlock = ^(LEVideoFinishState state) {
        switch (state) {
            case LEVideoFinishStateWithEnded:
                weakSelf.coverView.playBtn.selected = YES;
                weakSelf.playerOption.isPlaying = false;
                [weakSelf showCoverView];
                break;
                
            case LEVideoFinishStateWithError:
            {
#warning 播放错误的时候需要添加重新播放视频的按钮
            }
                break;
            default:
                break;
        }
        if (weakSelf.delegate &&[self.delegate respondsToSelector:@selector(le_playerControl:videoPlayFinish:)]) {
            [weakSelf.delegate le_playerControl:weakSelf videoPlayFinish:state];
        }
    };
    // 播放状态 做UI的更新
    self.manager.videoPlayStateBlock = ^(LEPlaybackState status) {
        switch (status) {
            case LEPlaybackStateStopped:
                
                break;
            case LEPlaybackStatePlaying:
                [weakSelf removeLoadingView];
                
                break;
            case LEPlaybackStatePaused:
                break;
            case LEPlaybackStateInterrupted:
                [weakSelf netShowView];
                break;
            default:
                break;
        }
        NSLog(@"播放器的播放状态变了，现在是暂停状态%ld",(long)status);
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(le_playerControl:videoPlayBackState:)]) {
            [weakSelf.delegate le_playerControl:weakSelf videoPlayBackState:status];
        }
    };

}



#pragma mark - 视图创建
- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateEvent) userInfo:nil repeats:YES];
    }
    return _timer;
}


- (UIView *)playerBaseView{
    if (!_playerBaseView) {
        _playerBaseView = [[UIView alloc]init];
        [self insertSubview:self.playerBaseView atIndex:1];
        [_playerBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
    }
    return _playerBaseView;
}


- (LELoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[LELoadingView alloc]init];
        [self.playerBaseView insertSubview:self.loadingView atIndex:3];
        
        [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.playerBaseView);
        }];
    }
    return _loadingView;
}
- (void)showLoadingView
{
    [self.loadingView showAndStartAnimation];
}

- (void)removeLoadingView
{
    [self.loadingView hideAndStopAnimation];
}


- (LENetNotiView *)netShowView{
    __weak typeof(self) weakSelf = self;
    if (!_netShowView) {
        _netShowView = [[LENetNotiView alloc]init];
        [self.playerBaseView insertSubview:_netShowView atIndex:4];
        [_netShowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        _netShowView.btnClickblock = ^{
            [weakSelf play];
        };
    }
    return _netShowView;
}

- (UIImageView *)playerPlaceHolderImg{
    if (!_playerPlaceHolderImg) {
        _playerPlaceHolderImg = [[UIImageView alloc]init];
        _playerPlaceHolderImg.contentMode = UIViewContentModeScaleAspectFit;
        _playerPlaceHolderImg.image = loadImage(self.playerPlaceHolderImgName);
    }
    return _playerPlaceHolderImg;
}
- (LECoverView *)coverView{
    if (!_coverView) {
        _coverView = [[LECoverView alloc]init];
        _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    }
    return _coverView;
}

-(void)hiddenCoverView{
    self.coverView.hidden = self.isHideTool = YES;
    self.coverView.hiddenSettingView = YES;
}

- (void)showCoverView{
    self.coverView.hidden = NO;
    self.isHideTool = self.coverView.hidden;
}


#pragma mark - 播放View及回调
-(void)createCoverView
{
    self.isHideTool = NO;
    __weak typeof(self) WeakSelf = self;
    [self.playerBaseView insertSubview:self.coverView atIndex:2];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top
        .bottom.equalTo(self.playerBaseView);
    }];
    
    // 返回事件
    self.coverView.returnBackBlock = ^(UIButton * _Nonnull sender) {
        [WeakSelf destoryControl];
        if (self.delegate && [self.delegate respondsToSelector:@selector(backBtnCLick:)]) {
            [WeakSelf.delegate backBtnCLick:nil];
        }
    };
    
    // 全屏点击事件
    self.coverView.fullBtnActionBlock = ^(UIButton * _Nonnull sender) {
        
    } ;
    
    // 滑块回调
    self.coverView.sliderEventBlock = ^(UISlider * _Nonnull slider) {
        WeakSelf.playerOption.isPlaying = NO;
        NSTimeInterval duration = [WeakSelf.manager get_duration];
        NSTimeInterval current = [WeakSelf.manager get_currentPlaybackTime];
        double value = slider.value * duration;
        if (value == duration && duration > 5.00) {
            value = duration - 5;
        }
        else if (value == duration && duration <= 5.0)
        {
            value = duration * 0.8;
        }
        [WeakSelf.manager set_currentPlaybackTime:value];
        
        WeakSelf.playerOption.currenTime = value;
        NSString *currentTime = [WeakSelf TimeformatFromSeconds:current];
        WeakSelf.coverView.lblCurrentTime.text = currentTime;
        WeakSelf.playerOption.isPlaying = YES;
    };
    
    // 中心播放按钮
    self.coverView.playActionBlock = ^(BOOL isSelected) {
         [NSObject cancelPreviousPerformRequestsWithTarget:WeakSelf selector:@selector(hiddenCoverView) object:nil];
        if (isSelected) {
            [WeakSelf pause];
        }else{
            [WeakSelf play];
            //播放时,取消屏幕cover显示
            [WeakSelf performSelector:@selector(hiddenCoverView) withObject:nil afterDelay:4];
        }
    };
    
    // 切换视频
    self.coverView.swithVideoBlock = ^(VideoStreamPannel videoStream, NSInteger row) {
        
        if (videoStream == VideoStreamPannelWithSpeed) {
            NSLog(@"VideoBoxPannelWithSpeed");

            if (row > self.playerOption.speedList.count-1) {
                return ;
            }else{
                 LEVideoStreamModel *vModel = WeakSelf.playerOption.speedList[row];
                [WeakSelf.manager set_playRate:[vModel.value floatValue]];
            }
            
        }else{
            NSLog(@"zz==zz");
            [WeakSelf replaceUrl:@""];
        }
        
    };
}



#pragma mark - 手势事件(控制音量及亮度)
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[LEButton class]]||[touch.view isKindOfClass:[UISlider class]]){
        return NO;
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    self.startPoint = [[touches anyObject] locationInView:self.playerView];
    self.isHideTool = !self.isHideTool;
    //每次点击取消还在进程中的隐藏方法
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenCoverView) object:nil];
    [self.playerBaseView bringSubviewToFront:self.coverView];
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.hidden = !self.coverView.hidden;
        self.isHideTool = self.coverView.hidden;
        self.coverView.hiddenSettingView = YES;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hiddenCoverView) withObject:nil afterDelay:4];
    }];
    
    if (self.startPoint.x > (self.frame.size.width - self.frame.size.width / 3.0)) {
        //音/量
        self.startVB = self.volumeViewSlider.value;
    }else if(self.startPoint.x < self.frame.size.width / 3.0){
        //亮度
        self.startVB = [UIScreen mainScreen].brightness;
    }
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.playerView];

    float dy = point.y - self.startPoint.y;
    if (fabsf(dy) < 1 )return;
    if (self.startPoint.x > (self.frame.size.width - self.frame.size.width / 3.0)) {
        if(dy>0){
            // 减小音量
            if(self.startVB>0.1){
                self.startVB = self.startVB-0.05;
                [self.volumeViewSlider setValue:self.startVB animated:YES];
                [self.volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }else{
            if(self.startVB>=0 && self.startVB<1){
                self.startVB = self.startVB+0.05;
                [self.volumeViewSlider setValue:self.startVB animated:YES];
                [self.volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
    }else if(self.startPoint.x < self.frame.size.width / 3.0){
        if (dy < 0) {
            //增加亮度
            if(self.startVB>=0 && self.startVB<1){
                self.startVB = self.startVB+0.05;
                [[UIScreen mainScreen] setBrightness:self.startVB];
            }
        } else {
            //减少亮度
            if(self.startVB>0.1){
                self.startVB = self.startVB-0.05;
                [[UIScreen mainScreen] setBrightness:self.startVB];
            }
            
        }
    }

    
}

- (MPVolumeView *)volumeView {
    if (_volumeView == nil) {
        _volumeView  = [[MPVolumeView alloc] init];
        [_volumeView sizeToFit];
        for (UIView *view in [_volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                self.volumeViewSlider = (UISlider*)view;
                break;
            }
        }
    }
    return _volumeView;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.layerContainer removeFromSuperlayer];
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.layerContainer removeFromSuperlayer];
}

#pragma mark -点击滑块操作
-(void)sliderTap:(UITapGestureRecognizer *)tap{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    UISlider * slider = (UISlider *)tap.view;
    CGPoint point = [tap locationInView:self.coverView.sliderView];
    double value = point.x/self.coverView.sliderView.bounds.size.width*1;
    NSTimeInterval duration = [self.manager get_duration];
    if (value == duration && duration > 5.00) {
        value = duration - 5;
    }
    else if (value == duration && duration <= 5.0)
    {
        value = duration * 0.8;
    }
    
    [self.coverView.sliderView setValue:value animated:YES];
    
    self.coverView.lblCurrentTime.text =[self TimeformatFromSeconds:[self.manager get_currentPlaybackTime]];
    [self.manager set_currentPlaybackTime:slider.value*duration];
    self.playerOption.currenTime = slider.value*duration;
    [self performSelector:@selector(hiddenCoverView) withObject:nil afterDelay:4];
    NSLog(@"滑块的点击操作");
}



#pragma mark 播放器事件
-(void)updateEvent{
    if ([self.manager get_playState] && self.playerOption.isPlaying) {
        self.playerOption.currenTime = [self.manager get_currentPlaybackTime];
        self.coverView.lblCurrentTime.text =[self TimeformatFromSeconds:[self.manager get_currentPlaybackTime]];
        NSTimeInterval total = [self.manager get_duration];
        NSTimeInterval able = [self.manager get_playableDuration];
        NSTimeInterval current = [self.manager get_currentPlaybackTime];
        [self.coverView.sliderView setValue:current/total animated:YES];
        [self.coverView.progressView setProgress:able/total animated:YES];
    }
}

-(void)play
{
    self.playerOption.isPlaying = YES;
    self.coverView.playBtn.selected = NO;
    
    [self.manager play];
}

-(void)pause
{
    self.playerOption.isPlaying = NO;
    self.coverView.playBtn.selected = YES;
    [self.manager pause];
}


-(void)stop
{
    self.playerOption.isPlaying = NO;
    [self.manager stop];
}

- (void)prepareToPlay{
    self.playerOption.isPlaying = YES;
    [self.manager prepareToPlay];
}

- (NSString*)TimeformatFromSeconds:(NSInteger)seconds
{
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}


// MARK: - 更换播放源
- (void)replaceUrl:(NSString *)videoUrl{
    
    NSString *url1 = @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
    if ([url1 isEqualToString:self.url]) {
        self.url = @"http://fastwebcache.yod.cn/yanglan/2013suoluosi/2013suoluosi_850/2013suoluosi_850.m3u8";
    }else{
        self.url = @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
    }
    [self stop];
    if (_manager) {
        self.playerView = nil;
        [_manager desctoryManager];
        _manager = nil;
    }
    
    [self initIJKPlayerControl: self.url];
    
}




// MARK:- 网络监听
- (void)licenceNetwork{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
//    NSString *remoteHostName = @"https://www.baidu.com";
//    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
//    [self.hostReachability startNotifier];
//    [self updateInterfaceWithReachability:self.hostReachability];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
}


- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
     NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    NSLog(@"++++网络状态:%ld",(long)netStatus);
    
    if (netStatus != NotReachable) {
        if (self.playerOption.isPlaying) {
            [self play];
        }
        
    }else{
        [self netShowView];
    }
}


#pragma mark - 释放视频播放器
-(void)destoryControl
{
    
    if (_manager) {
        [_manager desctoryManager];
        _manager = nil;
    }
    
    if (_playerBaseView) {
//        [_playerView.layer removeFromSuperlayer];
        for (UIView *subview in self.playerBaseView.subviews) {
            [subview removeFromSuperview];
        }
        [_playerBaseView removeFromSuperview];
        _playerBaseView = nil;
    }
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    
}




@end
