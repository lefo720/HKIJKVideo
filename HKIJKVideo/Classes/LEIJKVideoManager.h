//
//  LEIJKVideoManager.h
//  FBSnapshotTestCase
//
//  Created by Lefo on 2019/8/20.
//

#import <UIKit/UIKit.h>
#import "LEPlayerProtocal.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

NS_ASSUME_NONNULL_BEGIN

@interface LEIJKVideoManager : NSObject<LEPlayerProtocal>

// IJKplayer播放器
@property(nonatomic,strong)IJKFFMoviePlayerController *player;


- (instancetype)initWithURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
