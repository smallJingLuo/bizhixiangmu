//
//  LJCollectChildViewController.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/11/4.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJCollectChildViewController.h"
#import "LJDBManager.h"

@interface LJCollectChildViewController ()

@end

@implementation LJCollectChildViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    self.dataArray = [[[LJDBManager sharedManager] getAllData] mutableCopy];
    [self.tableView reloadData];
}

- (void)refreshView {
    
}

#pragma mark UITableViewDatasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LJTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TABLEVIEWCELL" forIndexPath:indexPath];
    if (self.dataArray.count > 0) {
        cell.model = self.dataArray[indexPath.row];
    }
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.hidden = YES;
        }
    }
    return cell;
}

#pragma mark UITableViewDelegate
//是否允许编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//编辑模式是什么
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
//删除cell
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([[LJDBManager sharedManager] deletePictrueModel:self.dataArray[indexPath.row]]) {
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
            [self.hudManager showSuccessWithMessage:@"删除成功"];
        }else {
            [self.hudManager showErrorWithMessage:@"删除失败"];
        }
    }
}
//将删除按钮改为中文
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}



@end
