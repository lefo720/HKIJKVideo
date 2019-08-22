//
//  LEAVPlayerManager.h
//  FBSnapshotTestCase
//
//  Created by Lefo on 2019/7/20.
//  Copyright © 2019年 Lefo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEPlayerProtocal.h"
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LEAVPlayerManager : NSObject<LEPlayerProtocal>

- (instancetype)initWithURL:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END
