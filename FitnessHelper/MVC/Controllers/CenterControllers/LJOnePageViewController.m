//
//  LJOnePageViewController.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/25.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJOnePageViewController.h"
#import "UIView+Screenshot.h"
#import "UIImage+ImageEffects.h"
#import "FancyTabBar.h"
#import "LJRootViewController.h"
#import "LJMultiViewController.h"
#import "LJSearchViewController.h"
#import "LJClassifyViewController.h"
#import "LJObjectsViewController.h"
#import "LJTableRootViewController.h"

typedef enum :int {
    OnePassageTypeMulti,
    OnePassageTypeClassify,
    OnePassageTypeSearch
}OnePassageType;

@interface LJOnePageViewController ()<FancyTabBarDelegate>

@property(nonatomic,strong) FancyTabBar *fancyTabBar;
@property (nonatomic,strong) UIImageView *backgroundView;

@property (nonatomic, strong) NSMutableArray *controllers;

@property (nonatomic, strong) NSArray *categoryArray;


@end

@implementation LJOnePageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _categoryArray = @[@"综合",@"分类",@"搜索"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_06.jpg"]];
    imageView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    _fancyTabBar = [[FancyTabBar alloc]initWithFrame:self.view.bounds];
    [_fancyTabBar setUpChoices:self choices:@[@"gallery",@"dropbox",@"draw"] withMainButtonImage:[UIImage imageNamed:@"main_button"]];
    [self.view addSubview:imageView];
    //[_fancyTabBar sendSubviewToBack:imageView];
    _fancyTabBar.delegate = self;
    [self.view addSubview:_fancyTabBar];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100, self.view.frame.size.height / 3 - 100, 200, 100)];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"让壁纸陪你走过美好时光"];
    label.font = [UIFont systemFontOfSize:32];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:240.0/255.0 green:245.0/255.0 blue:250.0/255.0 alpha:1] range:NSMakeRange(0, 2)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:26] range:NSMakeRange(2, 1)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:200.0/255.0 green:239.0/255.0 blue:210.0/255.0 alpha:1] range:NSMakeRange(2, 1)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:199.0/255.0 green:199.0/255.0 blue:200.0/255.0 alpha:1] range:NSMakeRange(3, 8)];
    NSShadow * show = [[NSShadow alloc] init];
    show.shadowColor = [UIColor colorWithRed:198.0/255.0 green:234.0/255.0 blue:205.0/255.0 alpha:0.4];
    show.shadowOffset = CGSizeMake(2, 5);
    [str addAttribute:NSShadowAttributeName value:show range:NSMakeRange(0, 11)];
    
    label.attributedText = str;
    label.numberOfLines = 0;
    
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    
    _controllers = [NSMutableArray array];
   
    [self setViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FancyTabBarDelegate
- (void) didCollapse{
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        if(finished) {
            [_backgroundView removeFromSuperview];
            _backgroundView = nil;
        }
    }];
}


- (void) didExpand{
    if(!_backgroundView){
        _backgroundView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _backgroundView.alpha = 0;
        [self.view addSubview:_backgroundView];
    }
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
    
    [self.view bringSubviewToFront:_fancyTabBar];
    UIImage *backgroundImage = [self.view convertViewToImage];
    UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    UIImage *image = [backgroundImage applyBlurWithRadius:10 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
    _backgroundView.image = image;
}

- (void)optionsButton:(UIButton*)optionButton didSelectItem:(int)index{
    //NSLog(@"Hello index %d tapped !", index);
    OnePassageType type = [self onePassageTypeForIndex:index];
    LJRootViewController *rootVC;
    switch (type) {
        case OnePassageTypeMulti:
        {
            rootVC = [[LJMultiViewController alloc] initWithSubTitles:@[@"最热",@"最新",@"分享榜",@"高清",@"热搜",@"套图",@"性感"] addControllers:_controllers];
        }
            break;
        case OnePassageTypeClassify:
        {
            rootVC = [[LJClassifyViewController alloc] init];
        }
            break;
        case OnePassageTypeSearch:
        {
            rootVC = [[LJSearchViewController alloc] init];
        }
            break;
        
            
        default:
            break;
    }
    [rootVC setTitle:_categoryArray[type]];
    [self.navigationController pushViewController:rootVC animated:YES];
    
}

- (OnePassageType)onePassageTypeForIndex:(int)index {
    OnePassageType types[] = {OnePassageTypeMulti,OnePassageTypeClassify,OnePassageTypeSearch};
    return index <= 3 ?types[index - 1]:OnePassageTypeMulti;
}

#pragma mark 创建viewControllers
- (void) setViewControllers {
    NSArray *viewControllesStr = @[@"LJHotViewController",@"LJFreshViewController",@"LJShareViewController",@"LJDistinctViewController",@"LJFindViewController",@"LJPictureViewController",@"LJSexyViewController"];
    for (int index = 0; index < viewControllesStr.count; index ++) {
        Class class = NSClassFromString(viewControllesStr[index]);
        if (index == 5 || index == 6) {
            LJTableRootViewController *tableVC = [[class alloc] init];
            tableVC.urlStr = @"http://360web.shoujiduoduo.com/wallpaper/wplist.php?user=868637010417434&prod=WallpaperDuoduo2.3.6.0&isrc=WallpaperDuoduo2.3.6.0_360ch.apk&type=getlist&listid=%ld&st=no&pg=%ld&pc=20&mac=802275a25111&dev=K-Touch%%253ET6%%253EK-Touch%%2BT6&vc=2360";
            tableVC.viewControllerType = index;
            [_controllers addObject:tableVC];
        }else {
            LJObjectsViewController *object = [[class alloc] init];
            object.urlStr = @"http://360web.shoujiduoduo.com/wallpaper/wplist.php?user=868637010417434&prod=WallpaperDuoduo2.3.6.0&isrc=WallpaperDuoduo2.3.6.0_360ch.apk&type=getlist&listid=%ld&st=no&pg=%ld&pc=20&mac=802275a25111&dev=K-Touch%%253ET6%%253EK-Touch%%2BT6&vc=2360";
            object.viewControllerType = index;
            object.isFromClassify = NO;
            object.isFromSearch = NO;
            [_controllers addObject:object];
        }
        
    }
}



@end
