//
//  LJCoverPictrueViewController.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/11/4.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJCoverPictrueViewController.h"


@interface LJCoverPictrueViewController ()

@end

@implementation LJCoverPictrueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) agenAddUI {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width - 40, 100)];
    label.text = [NSString stringWithFormat:@"简介:%@",self.desc];
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:label];
}

- (void)loadData {
    if (!self.dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self requestData];
}

- (void) requestData {
    [self.manager GET:self.urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:responseObject error:nil];
        NSArray *array = [document.rootElement childrenWithTag:@"img"];
        for (ONOXMLElement *element in array) {
            NSDictionary *dict = element.attributes;
            LJCollectionObjectModel *model = [[LJCollectionObjectModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            model.baseurl = document.rootElement.attributes[@"baseurl"];
            
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
        [self addUI:self.dataArray[0]];
        [self agenAddUI];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
