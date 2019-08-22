# HKIJKVideo

[![CI Status](https://img.shields.io/travis/lefo720/HKIJKVideo.svg?style=flat)](https://travis-ci.org/lefo720/HKIJKVideo)
[![Version](https://img.shields.io/cocoapods/v/HKIJKVideo.svg?style=flat)](https://cocoapods.org/pods/HKIJKVideo)
[![License](https://img.shields.io/cocoapods/l/HKIJKVideo.svg?style=flat)](https://cocoapods.org/pods/HKIJKVideo)
[![Platform](https://img.shields.io/cocoapods/p/HKIJKVideo.svg?style=flat)](https://cocoapods.org/pods/HKIJKVideo)

## Example
> 初始化播放器配置
	
	// 初始化数据
    self.playerOptions = [[LEPlayerOption alloc]init];
    self.playerOptions.isLiving = false;
    // 倍速
    self.playerOptions.speedList = speedArray.copy;
    // 质量
    self.playerOptions.qualityList = qualityArray.copy;
    // 使用播放器 0.AVPlayer 1.ijkPlayer
    self.playerOptions.playManager = LEPlayerManagerWithAVPlayer;
    

> 将播放器添加到当前控制器
	
	self.playerControlView = [[LEPlayerControl alloc]initWithFrame:CGRectZero];
    CGRect frame = self.view.bounds;
    self.playerControlView.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
    self.playerControlView.delegate = self;
    self.playerControlView.playerOption = self.playerOptions;
    [self.view addSubview:self.playerControlView];
    
    SString *remoteUrl = @"";
    [self.playerControlView playVideo:remoteUrl];
	

##使用说明:
<li>1.项目配置了,两种播放器:IJKPlayer和AVPlayer, 分别对应LEAVPlayerManager和LEIJKVideoManager, 如果只需要一种, 只需要将另外一个类删除.无需改动代码
<li>2.如果想添加自己的manager, 需要实现LEPlayerProtocal协议, 并实现协议中的函数,添加初始化manager配置即可
<li>3.播放器的回调,都在LEPlayerDelegate.h中, 使用时候需要当前viewcontroller实现该协议

住:部分类是从其他项目而来,切spec没有配置Github, 使用时候直接下载源码即可, 鄙人只是菜鸟, 大神勿喷

## Author

lefo720, lilei1@gaosiedu.com

## License

HKIJKVideo is available under the MIT license. See the LICENSE file for more info.
