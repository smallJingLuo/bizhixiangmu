//
//  LJDetailViewController.h
//  FitnessHelper
//
//  Created by 成都千锋 on 15/11/3.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import <Ono.h>
#import <UIImageView+WebCache.h>
#import "LJCollectionObjectModel.h"
#import "LJCollectionObjectModel.h"
#import "LJSeeViewController.h"

#define TABBAR_ITEM_BEGIN_TAG 200

typedef enum :NSInteger{
    LJTabBarItemWithViewControllerTypeCollect = TABBAR_ITEM_BEGIN_TAG,
    LJTabBarItemWithViewControllerTypeShare,
    LJTabBarItemWithViewControllerTypeSee
}LJTabBarItemWithViewControllerType;



@interface LJDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITabBarDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger currentCellIndex;

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

- (void) addUI:(LJCollectionObjectModel *)model;



@end
