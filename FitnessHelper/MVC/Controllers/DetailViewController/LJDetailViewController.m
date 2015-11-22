//
//  LJDetailViewController.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/11/3.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJDetailViewController.h"

#import <ShareSDK/ShareSDK.h>

@interface LJDetailViewController (){
    //UITableView *_tableView;
    //AFHTTPRequestOperationManager *_manager;
    //NSInteger _currentCellIndex;  //当前的cell
}

@end

@implementation LJDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 界面相关
- (void) setupUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, self.view.bounds.size.height, self.view.bounds.size.width) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = self.view.bounds.size.width;
    _tableView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    //tableView逆时针旋转90度
    _tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    _tableView.pagingEnabled = YES;
    _tableView.showsVerticalScrollIndicator = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:_tableView];
    
    UITabBar *tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 112, self.view.bounds.size.width, 44)];
    tabBar.delegate = self;
    NSArray *titleArray = @[@"收藏",@"分享",@"预览"];
    NSArray *imageArray = @[@"tabbar-tweet@3x",@"tabbar-news@2x",@"tabbar-discover@2x"];
    NSArray *selectImage = @[@"tabbar-tweet-selected@3x",@"tabbar-news-selected@3x",@"tabbar-discover-selected@3x"];
    NSMutableArray *itemArray = [NSMutableArray array];
    for (int i = 0; i < titleArray.count; i ++) {
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:titleArray[i] image:nil tag:TABBAR_ITEM_BEGIN_TAG + i];
        [itemArray addObject:item];
        item.image = [UIImage imageNamed:imageArray[i]];
        item.selectedImage = [UIImage imageNamed:selectImage[i]];

    }
    tabBar.items = itemArray;
    [self.view addSubview:tabBar];
    
    [self addUI:_dataArray[0]];
}


#pragma mark 表格视图数据源和委托的回调方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DETAILCELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DETAILCELL"];
    }
    //将数据绑定到单元格上
    //cell顺指针旋转90度
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    //cell.backgroundColor = [UIColor colorWithRed:(arc4random() % 256) / 255.0 green:(arc4random() % 256) / 255.0 blue:(arc4random() % 256) / 255.0 alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    LJCollectionObjectModel *model = _dataArray[indexPath.row];
    UIImageView *imageView =[[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",model.baseurl,model.link]]];
    //imageView顺时针旋转90度
    imageView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    cell.backgroundView = imageView;
    cell.backgroundColor = [UIColor colorWithRed:10.0/255.0 green:11.0/255.0 blue:20.0/255.0 alpha:0.5];
    return cell;
}

#pragma mark 判断tableView是否滚动到底部或者是顶部
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _currentCellIndex = (int)(scrollView.contentOffset.y / scrollView.frame.size.width);
    if (scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y < 0) {
        //滑到底部
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"已是最后一张图片" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if (scrollView.contentOffset.y == 0) {
        //滑到顶部
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"已是第一张图片" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    LJCollectionObjectModel *model = _dataArray[_currentCellIndex];
    [self addUI:model];
}

- (void) addUI:(LJCollectionObjectModel *)model {
    self.navigationItem.title = [NSString stringWithFormat:@"%@(%ld/%ld)",model.name,(self.currentCellIndex + 1),self.dataArray.count];
    
}

#pragma mark UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    UIImageView *imageView = [[UIImageView alloc] init];
    LJCollectionObjectModel *model = _dataArray[_currentCellIndex];
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",model.baseurl,model.link];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    switch (item.tag) {
       
        case LJTabBarItemWithViewControllerTypeCollect:
        {
            [self collectPictrue:imageView];
        }
            break;
            case LJTabBarItemWithViewControllerTypeShare:
        {
            [self shareAlertVeiw:tabBar andImageUrl:imageView];
        }
            break;
            case LJTabBarItemWithViewControllerTypeSee:
        {
            LJSeeViewController *seeVC = [[LJSeeViewController alloc] init];
            seeVC.imageUrl = imageUrl;
            [self presentViewController:seeVC animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

- (void)collectPictrue:(UIImageView *)imageView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"已收藏到相册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImageWriteToSavedPhotosAlbum(imageView.image, nil, nil, nil);
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void) shareAlertVeiw:(UITabBar *)sender andImageUrl:(UIImageView *)imageview{
    //NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK pngImageWithImage:imageview.image]
                                                title:@"ShareSDK"
                                                  url:@"http://www.mob.com"
                                          description:@"图片"
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    //NSLog(@"分享成功");
                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"分享成功" preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                                    [alert addAction:okAction];
                                    [self presentViewController:alert animated:YES completion:nil];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    //NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
                                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]]
                                        preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                                    [alert addAction:okAction];
                                    [self presentViewController:alert animated:YES completion:nil];
                                }
                                
                            }];
}


@end
