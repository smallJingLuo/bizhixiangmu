//
//  LJSettingViewController.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/25.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJSettingViewController.h"
#import <UIImageView+WebCache.h>


@interface LJSettingViewController (){
    UIButton *button;
}


@end

@implementation LJSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *nameArray = @[@"清除缓存",@"提醒更换壁纸"];
    for (int i = 0; i < nameArray.count; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 140 + i * 60, 120, 20)];
        label.text = nameArray[i];
        label.backgroundColor = [UIColor clearColor];
        [self.view addSubview:label];
    }
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.view.frame.size.width - 100, 140, 60, 20);
    [button setTitle:@"清除" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cleanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    UISwitch *_switch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100, 200, 40, 20)];
    [_switch addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_switch];
                        
}

- (void)cleanButtonClicked:(UIButton *)sender {

        [[SDImageCache sharedImageCache] clearDisk];
        
        
        float tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
        
        NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize] : [NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize * 1024];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:clearCacheName preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
     [button setTitle:@"已清除" forState:UIControlStateNormal];
}



- (void)switchValueChange:(UISwitch *)sender {
    
    if (sender.on) {
        if ([UIApplication instanceMethodForSelector:@selector(registerUserNotificationSettings:)]) {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil]];
        }
        UILocalNotification *local = [[UILocalNotification alloc] init];
        local.alertTitle = @"提醒";
        local.alertBody = @"亲，你该跟换壁纸了";
        local.fireDate = [NSDate dateWithTimeIntervalSinceNow:(2 * 24 * 60 * 60)];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:local];
    }else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设置成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
