//
//  LJDBManager.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/11/4.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJDBManager.h"
#import <FMDB.h>

@implementation LJDBManager{
    FMDatabase *_dataBase;
}

+ (instancetype)sharedManager {
    static LJDBManager *manager = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if (!manager) {
            manager = [[LJDBManager alloc] init];
        }
    });
    return manager;
}

- (instancetype)init {
    NSString *path = [NSString stringWithFormat:@"%@/Documents/app.sqlite",NSHomeDirectory()];
    _dataBase = [[FMDatabase alloc] initWithPath:path];
    if (_dataBase) {
        if ([_dataBase open]) {
            NSString *sqlite = @"create table if not exists pictrue(id varchar(20),name varchar(50),thumb1 varchar(50),thumb2 varchar(50),thumb3 varchar(50),thumb4 varchar(50),desc varchar(500),baseurl varchar(50))";
            [_dataBase executeUpdate:sqlite];
        }
    }
    return self;
}

#pragma mark 数据库的增删改查
//检查元素是否存在
- (BOOL) isExistsWithId:(NSString *)appId {
    NSString *querySqlite = [NSString stringWithFormat:@"select *from pictrue where id = %@",appId];
    FMResultSet *set = [_dataBase executeQuery:querySqlite];
    if ([set next]) {
        return YES;
    }else {
        return NO;
    }
}
//添加元素
- (BOOL) addPictrueModel:(LJTableViewModel *)model {
    if (model.thumb1) {
        BOOL isExists = [self isExistsWithId:model.ID];
        if (isExists) {
            NSString *deleteSqlite = [NSString stringWithFormat:@"delete from pictrue where id = %@",model.ID];
            [_dataBase executeUpdate:deleteSqlite];
        }
        NSString *insertSqlite = @"insert into pictrue values(?,?,?,?,?,?,?,?)";
        BOOL success = [_dataBase executeUpdate:insertSqlite,model.ID,model.name,model.thumb1,model.thumb2,model.thumb3,model.thumb4,model.desc,model.baseurl,model.author];
        return success;
    }else {
        return NO;
    }
    
}

//删除元素
- (BOOL) deletePictrueModel:(LJTableViewModel *)model {
    BOOL isExists = [self isExistsWithId:model.ID];
    if (isExists) {
        NSString *deleteSqlite = @"delete from pictrue where id = ?";
        BOOL success = [_dataBase executeUpdate:deleteSqlite,model.ID];
        return success;
    }else {
        return NO;
    }
}

//获取所有元素
- (NSArray *) getAllData {
    NSString *sqlite = @"select *from pictrue";
    FMResultSet *set = [_dataBase executeQuery:sqlite];
    NSMutableArray *dataArray = [NSMutableArray array];
    while ([set next]) {
        LJTableViewModel *model = [[LJTableViewModel alloc] init];
        model.ID = [set stringForColumn:@"id"];
        model.name = [set stringForColumn:@"name"];
        model.thumb1 = [set stringForColumn:@"thumb1"];
        model.thumb2 = [set stringForColumn:@"thumb2"];
        model.thumb3 = [set stringForColumn:@"thumb3"];
        model.thumb4 = [set stringForColumn:@"thumb4"];
        model.desc = [set stringForColumn:@"desc"];
        model.baseurl = [set stringForColumn:@"baseurl"];
        [dataArray addObject:model];
    }
    return dataArray;
}

@end
