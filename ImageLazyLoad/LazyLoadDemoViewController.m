//
//  LazyLoadDemoViewController.m
//  TeamKnowledgeBase
//
//  Created by wangtie on 15/9/16.
//  Copyright (c) 2015年 wangtie. All rights reserved.
//

#import "LazyLoadDemoViewController.h"
#import "Masonry.h"
#import "LazyLoadCell.h"
#import "AFNetworking.h"
#import "NSDictionary+Accessors.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
@interface LazyLoadDemoViewController ()
@property (nonatomic,copy) NSArray *source;
@end

@implementation LazyLoadDemoViewController

#pragma mark -life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[LazyLoadCell class] forCellReuseIdentifier:@"lazyLoadCell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    static NSString *referer = @"http://image.baidu.com/i?tn=baiduimage&ipn=r&ct=201326592&cl=2&lm=-1&st=-1&fm=index&fr=&sf=1&fmq=&pv=&ic=0&nc=1&z=&se=1&showtab=0&fb=0&width=&height=&face=0&istype=2&ie=utf-8&word=cat&oq=cat&rsp=-1";
    [self setImageDownLoadValue:referer forHTTPHeaderField:@"Referer"];
    [self fetchDataFromServer];
    [self updateViewConstraints];
    // Do any additional setup after loading the view.
}
- (IBAction)reload:(id)sender {
    [self fetchDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)updateViewConstraints{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [super updateViewConstraints];
}
#pragma mark - Private method
- (void)fetchDataFromServer{
    static NSString *apiURL = @"http://image.baidu.com/i?tn=resultjson_com&word=dog&rn=60";
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:apiURL]];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * response, id responseObject, NSError * error) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"...Request success");
            NSArray *originalData = [responseObject arrayForKey:@"data"];
            NSMutableArray *data = [NSMutableArray array];
            for (NSDictionary *item in originalData) {
                if ([item isKindOfClass:[NSDictionary class]] && [[item stringForKey:@"hoverURL"] length] > 0) {
                    [data addObject:item];
                }
            }
            self.source = data;
        }else {
            NSLog(@"...Request fail");
            self.source = nil;
        }
        [self.tableView reloadData];
    }];
    [dataTask resume];
}


- (NSDictionary *)objectForRow:(NSInteger)row{
    if (row<self.source.count) {
        return self.source[row];
    }
    return nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.source.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LazyLoadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lazyLoadCell" forIndexPath:indexPath];
    
    NSDictionary *dict = [self objectForRow:indexPath.row];
    NSURL *targetURL = [NSURL URLWithString:[dict stringForKey:@"hoverURL"]];
//    NSLog(@"hoverURL :%@ \nrow:%@",[dict stringForKey:@"hoverURL"],indexPath);
    [self setCellImageView:cell imageView:cell.cellDetailView andImageViewURL:targetURL];
    [self setupCell:cell cellForRowAtIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self objectForRow:indexPath.row];
    CGFloat height = [dict floatForKey:@"height"];
    CGFloat width = [dict floatForKey:@"width"];
    if (dict && width > 0 && height > 0) {
        return tableView.frame.size.width / (float)width * (float)height;
    }
    return 44.0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
