//
//  LJSiderViewController.h
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/25.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RESideMenu.h>

typedef enum :NSInteger{
    LJCenterControllerTypeOnePage,
    LJCenterControllerTypeCollect,
    LJCenterControllerTypeSetting
}LJCenterControllerType;

@interface LJSiderViewController : UIViewController

/**边栏控制器*/
@property (nonatomic, strong) RESideMenu *menu;

/*!
 @brief 创建中心视图
 @param 中心视图类型
 @return 创建好的视图
 */
- (UIViewController *) loadCenterViewController:(LJCenterControllerType)centerControllerty;

@end
