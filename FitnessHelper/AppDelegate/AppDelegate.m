//
//  AppDelegate.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/25.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "AppDelegate.h"
#import <RESideMenu.h>
#import "LJSiderViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <QZoneConnection/QZoneConnection.h>



@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    //创建侧边栏
    LJSiderViewController *siderVC = [[LJSiderViewController alloc] init];
    RESideMenu *sideMenu = [[RESideMenu alloc] initWithContentViewController:[siderVC loadCenterViewController:LJCenterControllerTypeOnePage] leftMenuViewController:siderVC rightMenuViewController:nil];
    siderVC.menu = sideMenu;
    
    sideMenu.parallaxEnabled = NO;
    sideMenu.scaleContentView = YES;
    sideMenu.contentViewScaleValue = 0.95;
    sideMenu.scaleMenuView = NO;
    sideMenu.contentViewShadowEnabled = YES;
    sideMenu.contentViewShadowRadius = 4.5;
    sideMenu.contentViewInPortraitOffsetCenterX = -50;
    
    self.window.rootViewController = sideMenu;
    [self.window makeKeyAndVisible];
    
     [ShareSDK registerApp:@"bfc8be9b35d1"];//字符串api20为您的ShareSDK的AppKey
    /**
     连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"955780106"
                               appSecret:@"81d394377f739a46c8e8e4d4fc192633"
                             redirectUri:@"http://www.sharesdk.cn"];
    
    [ShareSDK connectWeChatWithAppId:@"wxd84f8d1963013953"   //微信APPID
                           appSecret:@"d4624c36b6795d1d99dcf0547af5443d"  //微信APPSecret
                           wechatCls:[WXApi class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"6k9c9GufJYav9rF8"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    //[ShareSDK connectQQWithQZoneAppKey:@"6k9c9GufJYav9rF8"
     //                qqApiInterfaceCls:[QQApiInterface class]
     //                  tencentOAuthCls:[TencentOAuth class]];
        return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:notification.alertTitle message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
