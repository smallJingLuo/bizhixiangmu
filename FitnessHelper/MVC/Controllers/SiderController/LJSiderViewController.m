//
//  LJSiderViewController.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/25.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJSiderViewController.h"
#import "LJBaseViewController.h"
#import "LJOnePageViewController.h"
#import "LJCollectViewController.h"
#import "LJSettingViewController.h"

@interface LJSiderViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UIImageView *_imageView;
}

@end

@implementation LJSiderViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [userInfo objectForKey:@"dict"];
    NSData *data = dict[@"headerImage"];
    UIImage *image = [UIImage imageWithData:data];
    if (image) {
        _imageView.image = image;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launchimage1"]];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundView = imageview;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //去掉多余显示的cell
    _tableView.tableFooterView = [[UIView alloc] init];
}

- (void)loadData {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"首页",@"我的收藏",@"设置", nil];
    }
    [_tableView reloadData];
}

#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 150.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 40, 100, 100)];
    //view.backgroundColor = [UIColor redColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width / 2 - 50 + 20, view.frame.size.height / 2 - 15 + 40, 100, 20)];
    label.text = @"点击添加头像";
    label.font = [UIFont systemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [view addSubview:label];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 40, 100, 100)];
    _imageView.layer.cornerRadius = 50;
    _imageView.layer.masksToBounds = YES;
    _imageView.backgroundColor = [UIColor colorWithWhite:200.0 alpha:0.5];
    _imageView.layer.borderWidth = 1.0;
    _imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerClicked:)];
    tap.numberOfTapsRequired = 1;
    [_imageView addGestureRecognizer:tap];
    [view addSubview:_imageView];
    return view;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LJCenterControllerType type = [self centerControllerTypeForIndex:indexPath.row];
    //切换中心视图控制器
    [self.menu setContentViewController:[self loadCenterViewController:type] animated:YES];
    [self.menu hideMenuViewController];
}

#pragma mark 将数字下标转换为控制器类型
- (LJCenterControllerType)centerControllerTypeForIndex:(NSInteger)index {
    LJCenterControllerType array[] = {LJCenterControllerTypeOnePage,LJCenterControllerTypeCollect,LJCenterControllerTypeSetting};
    return array[index];
}

#pragma mark 加载中心视图
- (UIViewController *) loadCenterViewController:(LJCenterControllerType)centerControllertype {
    LJBaseViewController *centerVC;
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"首页",@"我的收藏",@"设置", nil];
    }
    switch (centerControllertype) {
        case LJCenterControllerTypeOnePage:
        {
            centerVC = [[LJOnePageViewController alloc] init];
        }
            break;
            case LJCenterControllerTypeCollect:
        {
            centerVC = [[LJCollectViewController alloc] init];
        }
            break;
            case LJCenterControllerTypeSetting:
        {
            centerVC = [[LJSettingViewController alloc] init];
        }
            break;   
        default:
            break;
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:centerVC];
    [centerVC setNavigationTitle:_dataArray[centerControllertype]];
    [centerVC setNavigationItemName:nil addBackgroundImage:@"navigationbar-sidebar" addIsLeft:YES];
    [centerVC setNavigationBarTintColor:[UIColor colorWithRed:8.0/255.0 green:40.0/255.0 blue:12.0/255.0 alpha:1.0]];
    return nav;
}


- (void)headerClicked:(UITapGestureRecognizer *)tap {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //NSLog(@"%@",info);
    _imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *data = UIImagePNGRepresentation(_imageView.image);
    //NSString *str = [info objectForKey:UIImagePickerControllerReferenceURL];
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:data forKey:@"headerImage"];
    [userInfo setObject:dict forKey:@"dict"];
    [userInfo synchronize];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
