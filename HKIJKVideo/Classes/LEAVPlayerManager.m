//
//  LEAVPlayerManager.m
//  FBSnapshotTestCase
//
//  Created by Lefo on 2019/7/20.
//  Copyright © 2019年 Lefo. All rights reserved.
//

#import "LEAVPlayerManager.h"


@interface LEAVPlayerManager()
@property(nonatomic, copy) NSString *videoUrl;

@property(nonatomic, strong) AVPlayerLayer *playerLayer;
@property(nonatomic, strong) AVPlayer *player;;
@property(nonatomic, strong) AVPlayerItem *playerItem;
@end

@implementation LEAVPlayerManager

@synthesize videoLoadStateBlock = _videoLoadStateBlock;
@synthesize videoFinishBlock = _videoFinishBlock;
@synthesize videoPlayStateBlock = _videoPlayStateBlock;
@synthesize videoPreparePlayBlock = _videoPreparePlayBlock;

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        
        // 切换源需要更换item
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
        self.playerItem = playerItem;
        //如果要切换视频需要调AVPlayer的replaceCurrentItemWithPlayerItem:方法
        self.player = [AVPlayer playerWithPlayerItem:playerItem];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerMovieFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:[self.player currentItem]];

        [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
       
    }
    return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            
            // 准备播放
            if (self.videoPreparePlayBlock) {
                self.videoPreparePlayBlock();
            }
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            // 播放错误
            if (self.videoFinishBlock) {
                self.videoFinishBlock(LEVideoFinishStateWithError);
            }
            
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
       // 计算缓冲进度
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        //加载中
        if (self.videoLoadStateBlock) {
            self.videoLoadStateBlock(LEVideoLoadStateStalled);
        }
    }
    

}

- (void)playerMovieFinish:(NSNotification *)notif{
    if (self.videoFinishBlock) {
        self.videoFinishBlock(LEVideoFinishStateWithEnded);
    }
}

- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}

//MARK: - 协议
- (NSTimeInterval)get_duration{
    CMTime time = self.playerItem.duration;
    return time.value / time.timescale;
}

- (NSTimeInterval)get_currentPlaybackTime{
    return self.playerItem.currentTime.value/self.playerItem.currentTime.timescale;
}
- (NSTimeInterval)get_playableDuration{
    return [self get_duration] - [self get_currentPlaybackTime];
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
}

- (void)prepareToPlay{
    [self play];
}

- (CALayer *)get_playerView{
    return self.playerLayer;
}

- (BOOL)get_playState{
    if (self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
        return true;
    }
    return false;
}

- (void)set_playRate:(float)rate{
    self.player.rate = rate;
}
- (void)set_currentPlaybackTime:(NSTimeInterval)time{
    CMTime time1 = CMTimeMake(time, 1);
    [self.player seekToTime:time1];
}

- (void)desctoryManager{

    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_player pause];
    _player = nil;
    _playerItem = nil;
    [_playerLayer removeFromSuperlayer];
    _playerLayer = nil;
}

@end
