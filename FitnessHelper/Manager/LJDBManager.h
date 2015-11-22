//
//  LJDBManager.h
//  FitnessHelper
//
//  Created by 成都千锋 on 15/11/4.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJTableViewModel.h"

@interface LJDBManager : NSObject


/*!
 @brief 单例类方法
 */
+ (instancetype) sharedManager;

/*!
 @brief 添加元素
 @param model
 @return BOOL
 */
- (BOOL) addPictrueModel:(LJTableViewModel *)model;

/*!
 @brief 删除元素
 @param model
 @return BOOL
 */
- (BOOL) deletePictrueModel:(LJTableViewModel *)model;

/*!
 @brief 获取所有元素
 @return 装元素的数组
 */
- (NSArray *) getAllData;



@end
