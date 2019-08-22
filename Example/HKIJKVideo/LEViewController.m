//
//  LEViewController.m
//  HKIJLVideoPlayer
//
//  Created by lefo720 on 08/07/2019.
//  Copyright (c) 2019 lefo720. All rights reserved.
//

#import "LEViewController.h"
#import "LEAppDelegate.h"
#import "LEPlayerControl.h"
#import "LEPlayerOption.h"
#import "LEVideoController.h"
#import "LETools.h"

@interface UserModel : NSObject
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *age;
@end

@implementation UserModel
@end

@interface LEViewController ()

@property(nonatomic, copy) NSString *userName;
@end

@implementation LEViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
  
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    LEVideoController *videoVC = [[LEVideoController alloc] init];

    [self presentViewController:videoVC animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
