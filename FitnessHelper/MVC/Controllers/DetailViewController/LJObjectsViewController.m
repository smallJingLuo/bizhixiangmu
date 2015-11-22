//
//  LJObjectsViewController.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/29.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJObjectsViewController.h"
#import "AFNetworking.h"
#import "AFOnoResponseSerializer.h"
#import <Ono.h>
#import "LJComCell.h"
#import "LJCollectionObjectModel.h"
#import <MJRefresh.h>
#import "MBProgressHUDManager.h"
#import "LJDetailViewController.h"


@interface LJObjectsViewController () <UICollectionViewDelegate,UICollectionViewDataSource>{
    NSMutableArray *_dataArray;
    NSInteger _page;
    AFHTTPRequestOperationManager *_manager;
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *flowLayout;
}

@property (nonatomic, strong) MBProgressHUDManager *hudManager;

@end

@implementation LJObjectsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_isFromClassify) {
        self.navigationController.navigationBar.translucent = YES;
    }
}

- (MBProgressHUDManager *)hudManager {
    if (!_hudManager) {
        _hudManager = [[MBProgressHUDManager alloc] initWithView:self.view];
    }
    return _hudManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark 创建UI
- (void) setupUI {
    if (_isFromClassify) {
        self.navigationController.navigationBar.translucent = NO;
    }
    flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _isFromClassify?self.view.frame.size.height:self.view.frame.size.height - 104) collectionViewLayout:flowLayout];
    flowLayout.itemSize = CGSizeMake((flowLayout.collectionView.frame.size.width - 5) / 2 , self.view.frame.size.width / 2);
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
//    UICollectionViewLayoutAttributes *attrebutes = [[UICollectionViewLayoutAttributes alloc] init];
//    attrebutes.frame = CGRectMake(5, 0, (flowLayout.collectionView.frame.size.width - 15) / 2 , self.view.frame.size.width / 2);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerNib:[UINib nibWithNibName:@"LJComCell" bundle:nil] forCellWithReuseIdentifier:@"COMCELL"];
    [self.view addSubview:_collectionView];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self requestDataWithPage:_page];
    }];
    footer.automaticallyRefresh = NO;
    _collectionView.footer = footer;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        [_dataArray removeAllObjects];
        [self requestDataWithPage:_page];
    }];
    _collectionView.header = header;
}

#pragma mark 数据相关
- (void)loadData {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    _page = 0;
    _manager = [AFHTTPRequestOperationManager manager];
     //_manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    _manager.responseSerializer.acceptableContentTypes = [_manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    _manager.responseSerializer = [AFHTTPResponseSerializer  serializer];
   
    [self requestDataWithPage:_page];
}

- (void) requestDataWithPage:(NSInteger)page {
    NSString *newUrl = [NSString stringWithFormat:self.urlStr,self.viewControllerType,_page];
    [self.hudManager showMessage:@"正在加载"];
    [_manager GET:_isFromSearch?self.urlStr:newUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@",responseObject);
        //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:responseObject error:nil];
        
        NSArray * imageArray = [document.rootElement childrenWithTag:@"img"];
        
        for (ONOXMLElement * imageElement in imageArray) {
            NSDictionary * attrs = imageElement.attributes;
            LJCollectionObjectModel *model = [[LJCollectionObjectModel alloc] init];
            [model setValuesForKeysWithDictionary:attrs];
            model.baseurl = document.rootElement.attributes[@"baseurl"];
            //NSLog(@"%@",model.baseurl);
            //NSLog(@"%@",attrs);
//            NSString * name = attrs[@"name"];
//            NSString * link = attrs[@"link"];
            [_dataArray addObject:model];
        }
        [_collectionView reloadData];
        [_collectionView.footer endRefreshing];
        [_collectionView.header endRefreshing];
        [self.hudManager showSuccessWithMessage:@"加载成功"];
        //NSLog(@"%@",document);
        //[self dealwithResponseObject:str];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (_collectionView.footer.state == MJRefreshStateRefreshing) {
            _page --;
            if (_page < 0) {
                _page = 0;
            }
            [_collectionView.footer endRefreshing];
        }
        [_collectionView.header endRefreshing];
        [self.hudManager showErrorWithMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }];
}


//- (void) dealwithResponseObject:(NSString *)str {
//    NSArray *array = [str componentsSeparatedByString:@">"];
//    NSLog(@"%@",array);
//    NSMutableArray *mArray = [NSMutableArray array];
//    for (NSString *tempStr in array) {
//        NSArray *tempArray = [tempStr componentsSeparatedByString:@" "];
//        [mArray addObject:tempArray];
//    }
//    NSLog(@"%@",mArray);
//}

#pragma mark UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LJComCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"COMCELL" forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor lightGrayColor];
    if (_dataArray.count) {
        cell.model = _dataArray[indexPath.row];
    }
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LJDetailViewController *detailVC = [[LJDetailViewController alloc] init];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSInteger index = indexPath.row; index < _dataArray.count; index ++) {
        [tempArray addObject:_dataArray[index]];
    }
    detailVC.dataArray = tempArray;
    [self.navigationController pushViewController:detailVC animated:YES];
}





@end
