//
//  LECoverView.m
//  FBSnapshotTestCase
//
//  Created by Lefo on 2019/7/29.
//  Copyright © 2019年 Lefo. All rights reserved.
//

#import "LECoverView.h"
#import "LESettingTableView.h"
#import "LEImageTool.h"
#import "Masonry.h"


@interface LECoverView()<LESettingTableDelegate>
// 返回键
@property(nonatomic, strong) LEButton *backBtn;
// 全屏键
@property(nonatomic, strong) LEButton *fullScreenBtn;
// 锁屏键,暂时不用
@property(nonatomic, strong) LEButton *btnLock;

@property(nonatomic, strong) LEMarqueeLabel *titleLabel;

// 视频类型(mp4,录制件)
@property(nonatomic, strong) UIButton *videoTypeBtn;
// 播放速率
@property(nonatomic, strong) UIButton *speedBtn;
// 画质(原画 高清 标清)
@property(nonatomic, strong) UIButton *qualityBtn;
// 金币
@property(nonatomic, strong) UILabel *goldLabel;
// 成长值
@property(nonatomic, strong) UILabel *achieveLabel;

@property(nonatomic, strong) LESettingTableView *setTableView;
@end

@implementation LECoverView


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self createTopPanel];
        
        [self createBottomPanel];
        
        [self createScreenPanel];
        
    }
    return self;
}


//MARK:- 屏幕中部视图
- (void)createScreenPanel{
    //在coverView上面添加播放按钮
    self.playBtn = [[LEButton alloc]init];
    [self addSubview:_playBtn];
    
    [self.playBtn setImage:loadImage(@"pause") forState:(UIControlStateNormal)];
    [self.playBtn setImage:loadImage(@"play") forState:(UIControlStateSelected)];
    [self.playBtn addTarget:self action:@selector(playOption:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.width.height.mas_equalTo(100);
    }];
    
    
    //在coverView上面添加锁定按钮
    self.btnLock = [[LEButton alloc]init];
    [self.btnLock setImage:loadImage(@"lock1") forState:(UIControlStateNormal)];
    [self.btnLock setImage:loadImage(@"lockSel1") forState:(UIControlStateSelected)];
    [self.btnLock addTarget:self action:@selector(lock:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:self.btnLock];
    [self.btnLock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playBtn);
        make.left.equalTo(self.playBtn);
        make.width.height.mas_equalTo(40);
    }];
    
   
    [self addSubview:self.setTableView];
    [self.setTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backBtn.mas_bottom);
        make.left.equalTo(self.mas_right).offset(1);
        make.width.mas_equalTo(200);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}
//MARK: 底部视图(全屏,时间,滑块)
- (void)createBottomPanel{
    
    //在coverView上面添加全屏按钮
    self.fullScreenBtn = [[LEButton alloc]init];
//    [self.fullScreenBtn setImage:[self loadImage:@"fullScreen"] forState:(UIControlStateNormal)];
//    [self.fullScreenBtn setImage:[self loadImage:@"quiteScreen"] forState:(UIControlStateSelected)];
    [self addSubview:self.fullScreenBtn];
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(50);
    }];
    [self.fullScreenBtn addTarget:self action:@selector(fullScreen:) forControlEvents:(UIControlEventTouchUpInside)];
    self.fullScreenBtn.hidden = YES;
    
    //在coverView上面添加视频当前时间Label
    _lblCurrentTime = [[UILabel alloc]init];
    _lblCurrentTime.font = [UIFont systemFontOfSize:15];
    _lblCurrentTime.textAlignment = NSTextAlignmentLeft;
    _lblCurrentTime.textColor = [UIColor whiteColor];
    [self addSubview:_lblCurrentTime];
    [_lblCurrentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(_fullScreenBtn);
        make.width.mas_equalTo(65);
    }];
    
    //在coverView上面添加视频总时长Label
    _lblTotalTime = [[UILabel alloc]init];
    _lblTotalTime.font = [UIFont systemFontOfSize:15];
    
    _lblTotalTime.textAlignment = NSTextAlignmentRight;
    _lblTotalTime.textColor = [UIColor whiteColor];
    [self addSubview:_lblTotalTime];
    [_lblTotalTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_fullScreenBtn.mas_left);
        make.centerY.equalTo(_fullScreenBtn);
        make.width.mas_equalTo(65);
        
    }];
    
    //在coverView上面添加缓冲的进度条
    _progressView = [[UIProgressView alloc]init];
    [self addSubview:_progressView];
    _progressView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_lblCurrentTime.mas_right).offset(5);
        make.right.equalTo(_lblTotalTime.mas_left).offset(-5);
        make.centerY.equalTo(_fullScreenBtn);//progressView向下一个像素
    }];
    _progressView.tintColor = [UIColor whiteColor];
    [_progressView setProgress:0];
    
    
    
    
    //在coverView上面添加滑块
    _sliderView = [[UISlider alloc]init];
    _sliderView.userInteractionEnabled = YES;
    _sliderView.continuous = NO;//设置为NO,只有在手指离开的时候调用valueChange
    [_sliderView addTarget:self action:@selector(sliderTouchDownEvent:) forControlEvents:UIControlEventTouchDown];
    [_sliderView addTarget:self action:@selector(sliderValuechange:) forControlEvents:UIControlEventValueChanged];
    [_sliderView addTarget:self action:@selector(sliderTouchUpEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_sliderView addTarget:self action:@selector(sliderTouchUpEvent:) forControlEvents:UIControlEventTouchUpOutside];
    
    [self addSubview:_sliderView];
    [_sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.equalTo(_progressView);
        make.centerY.equalTo(_progressView);
        make.height.mas_equalTo(52);
    }];
    
    _sliderView.minimumTrackTintColor = [UIColor whiteColor];
    _sliderView.maximumTrackTintColor = [UIColor clearColor];
    _sliderView.minimumValue = 0;
    _sliderView.maximumValue = 1;
    _sliderView.enabled = YES;
    UIImage * image = [self createImageWithColor:[UIColor whiteColor]];
    UIImage * circleImage = [self circleImageWithImage:image borderWidth:0 borderColor:[UIColor clearColor]];
    [_sliderView setThumbImage:circleImage forState:(UIControlStateNormal)];
    
}

//MARK: 顶部视图(返回,视频名称,激励体系)
- (void)createTopPanel{
    @autoreleasepool {
        UIView *cLayer = [[UIView alloc]init];
        [self addSubview:cLayer];
        [self sendSubviewToBack:cLayer];
        [cLayer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(64);
            make.width.equalTo(self);
        }];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        
        gradient.colors = @[(id)[UIColor blackColor].CGColor,(id)[[UIColor blackColor] colorWithAlphaComponent:0.01].CGColor];
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint = CGPointMake(0, 1);
        [cLayer.layer addSublayer:gradient];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            gradient.frame = cLayer.frame;
        });
    }
    
    //在coverView上面添加返回按钮
    self.backBtn = [[LEButton alloc]init];
//    [self.backBtn setImage:[self loadImage:@"back"] forState:(UIControlStateNormal)];
    [self.backBtn setImage:loadImage(@"back") forState:(UIControlStateNormal)];
    
    [self addSubview:_backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(10);
        make.width.height.mas_equalTo(40);
    }];
    [self.backBtn addTarget:self action:@selector(back:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.titleLabel = [[LEMarqueeLabel alloc]init];
    self.titleLabel.text = @"GL_IMG_read_format GL_IMG_texture_compression_pvrtc GL_IMG_read_format GL_IMG_texture_compression_pvrtc ";
    self.titleLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    
    
    
    self.videoTypeBtn = [[LEButton alloc]init];
    [self.videoTypeBtn setTitle:@"视频" forState:UIControlStateNormal];
    [self addSubview:self.videoTypeBtn];
    self.videoTypeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.videoTypeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.videoTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60);
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.backBtn);
        make.height.mas_equalTo(30);
    }];
    [self.videoTypeBtn setImage:loadImage(@"fullScreen") forState:UIControlStateNormal];
    
    [self.videoTypeBtn addTarget:self action:@selector(switchMedia:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.speedBtn = [[LEButton alloc]init];
    [self.speedBtn setTitle:@"倍速" forState:UIControlStateNormal];
    [self addSubview:self.speedBtn];
    self.speedBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.speedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.speedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.equalTo(self.videoTypeBtn);
        make.right.equalTo(self.videoTypeBtn.mas_left).
        offset(-10);
    }];
    
    [self.speedBtn addTarget:self action:@selector(switchSpeed:) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.qualityBtn = [[LEButton alloc]init];
    [self.qualityBtn setTitle:@"原画" forState:UIControlStateNormal];
    [self addSubview:self.qualityBtn];
    self.qualityBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.qualityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.qualityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.equalTo(self.videoTypeBtn);
        make.right.equalTo(self.speedBtn.mas_left).
        offset(-10);
    }];
    [self.qualityBtn addTarget:self action:@selector(switchQuality:) forControlEvents:(UIControlEventTouchUpInside)];
    
    // 激励体系
    self.achieveLabel = [[UILabel alloc]init];
    self.achieveLabel.font = [UIFont systemFontOfSize:12];
    self.achieveLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:self.achieveLabel];
    [self.achieveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.backBtn);
        make.right.equalTo(self.qualityBtn.mas_left).offset(-10);
        make.width.mas_equalTo(60);
    }];
    
    NSAttributedString *attri2 = [self attributeLabel:@"成长值体系" image:@"fullScreen"];
    self.achieveLabel.attributedText= attri2;
    
    self.goldLabel = [[UILabel alloc]init];
    self.goldLabel.font = [UIFont systemFontOfSize:12];
    self.goldLabel.textColor = [UIColor whiteColor];
    
    [self addSubview:self.goldLabel];
    [self.goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.backBtn);
        make.right.equalTo(self.achieveLabel.mas_left).offset(-5);
        make.width.equalTo(self.achieveLabel);
    }];
    
    NSAttributedString *attri1 = [self attributeLabel:@"金币体系" image:@"fullScreen"];
    self.goldLabel.attributedText= attri1;
    
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backBtn.mas_right);
        make.right.equalTo(self.goldLabel.mas_left).offset(-5);
        make.top.height.equalTo(self.backBtn);
    }];
    
    
}

- (NSAttributedString *)attributeLabel:(NSString *)text image:(NSString *)imgName{
    NSMutableAttributedString *attri1 = [[NSMutableAttributedString alloc]initWithString:text];
    NSTextAttachment*attch1 = [[NSTextAttachment alloc]init];
    attch1.image = loadImage(@"fullScreen");
    
    attch1.bounds=CGRectMake(0, -5,20,20);
    NSAttributedString*string1 = [NSAttributedString attributedStringWithAttachment:attch1];
    [attri1 insertAttributedString:string1 atIndex:0];
    return attri1.copy;
}

- (LESettingTableView *)setTableView{
    if (!_setTableView) {
         _setTableView = [[LESettingTableView alloc] init];
    }
    _setTableView.delegate = self;
    return _setTableView;
}
- (void)settingView:(LESettingTableView *)view didSelected:(NSIndexPath *)indexPath{
    
    if (self.swithVideoBlock) {
        self.swithVideoBlock(self.videoStream, indexPath.row);
    }
    [self hiddenSettingView];
    
}

- (void)drawRect:(CGRect)rect fill:(const CGFloat*)fillColors radius:(CGFloat)radius {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    if (fillColors) {
        CGContextSaveGState(context);
        CGContextSetFillColor(context, fillColors);
        if (radius) {
            UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
            CGContextAddPath(context, path.CGPath);
            CGContextFillPath(context);
        } else {
            CGContextFillRect(context, rect);
        }
        CGContextRestoreGState(context);
    }
    
    CGColorSpaceRelease(space);
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self cornerRadius:self.videoTypeBtn];
    [self cornerRadius:self.speedBtn];
    [self cornerRadius:self.qualityBtn];
    
}

- (void)cornerRadius:(UIButton *)sender{
    sender.layer.cornerRadius = sender.frame.size.height / 2;
    sender.layer.masksToBounds = true;
    sender.layer.borderWidth = 1;
    sender.layer.borderColor = [UIColor whiteColor].CGColor;
}

#pragma mark - 把颜色转变成为图片
- (UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0,0,15,15);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}




#pragma mark 生成一个待圆角的图片
- (UIImage *)circleImageWithImage:(UIImage *)oldImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 1.加载原图
    // 2.开启上下文
    CGFloat imageW = oldImage.size.width + 22 * borderWidth;
    CGFloat imageH = oldImage.size.height + 22 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    // 3.取得当前的上下文,这里得到的就是上面刚创建的那个图片上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 4.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆。As a side effect when you call this function, Quartz clears the current path.
    
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    
    // 7.取图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 8.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}



#pragma mark - 点击了全屏按钮
- (void)fullScreen:(LEButton *)sender
{
    NSLog(@"您点击了全屏按钮");
    sender.selected = !sender.selected;
    if (self.fullBtnActionBlock) {
        self.fullBtnActionBlock(sender);
    }
    
    
}

- (void)showArchieveView:(BOOL)isShow{
    self.goldLabel.hidden = !isShow;
    self.achieveLabel.hidden = !isShow;
}


#pragma mark 点击了返回按钮触发的事件
-(void)back:(UIButton *)sender
{
    NSLog(@"您点击了返回按钮");
    if (self.returnBackBlock) {
        self.returnBackBlock(sender);
    }
//    [_loadingView removeFromSuperview];
//    _loadingView = nil;
//    if (self.fullBtnOrBackBtnClickDelegate&&[self.fullBtnOrBackBtnClickDelegate respondsToSelector:@selector(fullBtnClick:)]) {
//        [self.fullBtnOrBackBtnClickDelegate backBtnCLick:sender];
//    }
    
}



#pragma mark 播放和暂停
-(void)playOption:(LEButton *)sender{
    
    
    sender.selected = !sender.selected;
    if (self.playActionBlock) {
        self.playActionBlock(sender.selected);
    }
//
    
    
}

#pragma mark 锁定按钮的点击方法
-(void)lock:(LEButton *)sender{
    //    sender.selected = !sender.selected;
    //    if (sender.selected) {
    //        for (UIView * subView in _coverView.subviews) {
    //            subView.alpha = 0;
    //        }
    //        sender.alpha = 1;
    //    }else{
    //    }
}



#pragma mark 滑块的touchDown方法
-(void)sliderTouchDownEvent:(UISlider *)sender
{
//    [self pauseWithoutRecoder];
//    _tapGesture.enabled = NO;
}


-(void)pauseWithoutRecoder
{
//    self.playBtn.selected = YES;
//    [self.player pause];
}



#pragma mark 滑块的touchUp方法
-(void)sliderTouchUpEvent:(UISlider *)sender
{
    if (self.sliderEventBlock) {
        self.sliderEventBlock(sender);
    }

}

#pragma mark 滑块的值发生改变
-(void)sliderValuechange:(UISlider *)sender{
    
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
//    [self performSelector:@selector(hide) withObject:nil afterDelay:4];
    NSLog(@"滑块的值发生了改变");
}

// MARK:- 右侧事件
- (void)switchMedia:(UIButton *)sender{
    NSLog(@"转换视频");
}

- (void)switchQuality:(UIButton *)sender{
    [UIView animateWithDuration:1 animations:^{
        [self.setTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_right).offset(-200);
        }];
    }];
    self.setTableView.dataArray = self.qualityList;
    self.videoStream = VideoStreamPannelWithQuality;
    
     [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenSettingView) object:nil];
    [self performSelector:@selector(hiddenSettingView) withObject:nil afterDelay:5];
    
}

- (void)switchSpeed:(UIButton *)sender{
    [UIView animateWithDuration:0.25 animations:^{
        [self.setTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_right).offset(-200);
        }];
    }];
    
    NSArray *data = self.speedList; //@[@"1.0X",@"1.5X",@"2.0X",@"2.5X"];
    self.setTableView.dataArray = data;
    self.videoStream = VideoStreamPannelWithSpeed;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenSettingView) object:nil];
    [self performSelector:@selector(hiddenSettingView) withObject:nil afterDelay:10];
}


- (BOOL)hiddenSettingView{
    [UIView animateWithDuration:1 animations:^{
        [self.setTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_right).offset(1);
        }];
    }completion:nil];
    return YES;
}





//MARK:- setVideoName
- (void)setVideoName:(NSString *)videoName{
    if (!videoName) {
        self.titleLabel.text = videoName;
    }
}

- (void)showLivingView:(BOOL)isLiving{
    self.sliderView.hidden = isLiving;
    self.lblCurrentTime.hidden = isLiving;
    self.lblTotalTime.hidden = isLiving;
    self.progressView.hidden = isLiving;
    self.sliderView.hidden = isLiving;
    self.sliderView.hidden = isLiving;
    self.qualityBtn.hidden = isLiving;
    self.speedBtn.hidden = isLiving;
    self.videoTypeBtn.hidden = isLiving;
}

- (void)setHiddenSettingView:(BOOL)hiddenSettingView{
    [self hiddenSettingView];
}

- (void)setGoldValue:(NSInteger)goldValue{
    NSString *goldString = [NSString stringWithFormat:@"%ld",goldValue];;
    NSAttributedString *attri1 = [self attributeLabel:goldString image:@"fullScreen"];
    self.goldLabel.attributedText= attri1;
}

- (void)setAchieveValue:(NSInteger)achieveValue{
    NSString *achieveString = [NSString stringWithFormat:@"%ld",achieveValue];;
    NSAttributedString *attri1 = [self attributeLabel:achieveString image:@"fullScreen"];
    self.achieveLabel.attributedText= attri1;
}

- (NSInteger)achieveValue{
    NSString *value = self.achieveLabel.text;
    return [value integerValue];
}

- (NSInteger)goldValue{
    NSString *value = self.goldLabel.text;
    return [value integerValue];
}



@end
