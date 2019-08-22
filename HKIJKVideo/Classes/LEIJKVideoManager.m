//
//  LEIJKVideoManager.m
//  FBSnapshotTestCase
//
//  Created by Lefo on 2019/8/20.
//

#import "LEIJKVideoManager.h"

@interface LEIJKVideoManager()

@end


@implementation LEIJKVideoManager

@synthesize videoLoadStateBlock = _videoLoadStateBlock;
@synthesize videoFinishBlock = _videoFinishBlock;
@synthesize videoPlayStateBlock = _videoPlayStateBlock;
@synthesize videoPreparePlayBlock = _videoPreparePlayBlock;



- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        //IJKplayer属性参数设置
        IJKFFOptions *options = [IJKFFOptions optionsByDefault];
        [options setOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_frame" ofCategory:kIJKFFOptionCategoryCodec];
        [options setOptionIntValue:IJK_AVDISCARD_DEFAULT forKey:@"skip_loop_filter" ofCategory:kIJKFFOptionCategoryCodec];
        [options setOptionIntValue:0 forKey:@"videotoolbox" ofCategory:kIJKFFOptionCategoryPlayer];
        [options setOptionIntValue:60 forKey:@"max-fps" ofCategory:kIJKFFOptionCategoryPlayer];
        [options setPlayerOptionIntValue:256 forKey:@"vol"];
        [options setFormatOptionIntValue:0 forKey:@"auto_convert"];
        
        if (_player) {
            [_player shutdown];
            _player = nil;
        }
        
        self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options];
        [self.player setScalingMode:IJKMPMovieScalingModeAspectFit];
        //设置缓存大小，太大了没啥用,太小了视频就处于边播边加载的状态，目前是10M，后期可以调整
        [self.player setPlayerOptionIntValue:10* 1024 *1024 forKey:@"max-buffer-size"];
        
        //添加通知方法
        [self installMovieNotificationObservers];

    }
    return self;
}
- (UIView *)get_playerView{
    if (self.player) {
        return self.player.view;
    }
    return nil;
}

#pragma mark - 视频播放器相关通知方法
- (void)installMovieNotificationObservers {
    [self removeMovieNotificationObservers];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    
    
}


#pragma mark 更新加载状态
- (void)loadStateDidChange:(NSNotification*)notification
{
    IJKMPMovieLoadState loadState = _player.loadState;
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0 || (loadState & MPMovieLoadStatePlayable) != 0) {
        NSLog(@"加载状态变成了已经缓存完成，如果设置了自动播放，这时会自动播放");
        
        if (self.videoLoadStateBlock) {
            self.videoLoadStateBlock(LEVideoLoadStatePlaythroughOK);
        }
        
    }
    if ((loadState & IJKMPMovieLoadStateStalled) != 0)
    {
        if (self.videoLoadStateBlock) {
            self.videoLoadStateBlock(LEVideoLoadStateStalled);
        }
    }
    if((loadState & IJKMPMovieLoadStatePlayable) != 0)
    {
        NSLog(@"加载状态变成了缓存数据足够开始播放，但是视频并没有缓存完全");
//        if (self.videoLoadStateBlock) {
//            self.videoLoadStateBlock(LEVideoLoadStatePlayable);
//        }
    }
    if ((loadState & IJKMPMovieLoadStateUnknown) != 0) {
        NSLog(@"加载状态变成了未知状态");
        if (self.videoLoadStateBlock) {
            self.videoLoadStateBlock(LEVideoLoadStateUnknown);
        }
        
        
    }
}


-(void)play
{
    [self.player play];
}

-(void)pause
{
   
    [self.player pause];
}


-(void)stop
{
    [self pause];
    [self.player stop];
}

- (void)prepareToPlay{
    [self.player prepareToPlay];
    [self play];
}

- (NSTimeInterval)get_duration{
    return self.player.duration;
}

- (NSTimeInterval)get_currentPlaybackTime{
    return self.player.currentPlaybackTime;
}
- (NSTimeInterval)get_playableDuration{
    return self.player.playableDuration;
}
- (BOOL)get_playState{
    return [self.player isPlaying];
}
- (void)set_playRate:(float)rate{
    self.player.playbackRate = rate;
}

- (void)set_currentPlaybackTime:(NSTimeInterval)time{
    self.player.currentPlaybackTime = time;
}
#pragma mark - 播放状态改变
- (void)moviePlayBackFinish:(NSNotification*)notification
{
    int reason = [[[notification userInfo]valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    if (self.videoPlayStateBlock) {
        self.videoFinishBlock(reason);
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    if (self.videoPreparePlayBlock){
        self.videoPreparePlayBlock();
    }
    
}

#pragma mark - 视频播放器状态改变
- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    int playState = _player.playbackState;
    if (self.videoPlayStateBlock) {
        LEPlaybackState state = playState;
        self.videoPlayStateBlock(state);
    }
    
//
//    //视频开始的时候开启计时器
//    [self.timer fire];
//    [self performSelector:@selector(hiddenCoverView) withObject:nil afterDelay:4];
//    switch (_player.playbackState) {
//        case IJKMPMoviePlaybackStateStopped:
//            self.playStatus = LEVideoPlayStatusStopped;
//            if (self.playerViewDelegate && [self.playerViewDelegate respondsToSelector:@selector(playerMPMoviePlaybackState:)]) {
//                [self.playerViewDelegate playerMPMoviePlaybackState:self.playStatus];
//            }
//            NSLog(@"播放器的播放状态变了，现在是停止状态:Stopped");
//            break;
//        case IJKMPMoviePlaybackStatePlaying:
//            self.playStatus = LEVideoPlayStatusPlaying;
//            [self removeLoadingView];
//            if (self.playerViewDelegate && [self.playerViewDelegate respondsToSelector:@selector(playerMPMoviePlaybackState:)]) {
//                [self.playerViewDelegate playerMPMoviePlaybackState:self.playStatus];
//            }
//
//            NSLog(@"播放器的播放状态变了，现在是播放状态:Playing");
//            break;
//        case IJKMPMoviePlaybackStatePaused:
//            self.playStatus = LEVideoPlayStatusPaused;
//            if (self.playerViewDelegate && [self.playerViewDelegate respondsToSelector:@selector(playerMPMoviePlaybackState:)]) {
//                [self.playerViewDelegate playerMPMoviePlaybackState:self.playStatus];
//            }
//            NSLog(@"播放器的播放状态变了，现在是暂停状态:Paused");
//            break;
//        case IJKMPMoviePlaybackStateInterrupted:
//            self.playStatus = LEVideoPlayStatusInterrupted;
//            NSLog(@"播放器的播放状态变了，现在是中断状态:Interrupted");
//            if (self.playerViewDelegate && [self.playerViewDelegate respondsToSelector:@selector(playerMPMoviePlaybackState:)]) {
//                [self.playerViewDelegate playerMPMoviePlaybackState:self.playStatus];
//            }
//            break;
//            /**
//             case IJKMPMoviePlaybackStateSeekingForward:
//             NSLog(@"播放器的播放状态变了，现在是向前拖动状态:%d",(int)self.player.playbackState);
//
//             self.playerOption.currenTime = self.player.currentPlaybackTime;
//             //            if (self.playerViewDelegate && [self.playerViewDelegate respondsToSelector:@selector(playerMPMoviePlaybackStateSeekingForward)]) {
//             //                [self.playerViewDelegate playerMPMoviePlaybackStateSeekingForward];
//             //            }
//             break;
//             case IJKMPMoviePlaybackStateSeekingBackward:
//             if (self.playerViewDelegate && [self.playerViewDelegate respondsToSelector:@selector(playerMPMoviePlaybackStateSeekingBackward)]) {
//             [self.playerViewDelegate playerMPMoviePlaybackStateSeekingBackward];
//             }
//             NSLog(@"播放器的播放状态变了，现在是向后拖动状态：%d",(int)self.player.playbackState);
//             break;
//             */
//        default:
//            if (self.videoDelegate && [self.videoDelegate respondsToSelector:@selector(playerMPMovieFinishReasonPlaybackError)]) {
//                [self.videoDelegate playerMPMovieFinishReasonPlaybackError];
//            }
//            NSLog(@"播放器的播放状态变了，现在是未知状态：%d",(int)self.player.playbackState);
//            break;
//    }
}

- (void)desctoryManager{
    if (_player) {
        [_player stop];
        [_player shutdown];
        [_player.view removeFromSuperview];
        _player = nil;
        
    }
    [self removeMovieNotificationObservers];
}

#pragma mark - 移除通知
- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
    
}


@end
