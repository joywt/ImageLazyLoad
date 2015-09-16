//
//  ImageLazyLoadViewController.h
//  TeamKnowledgeBase
//
//  Created by wangtie on 15/9/15.
//  Copyright (c) 2015年 wangtie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import <objc/runtime.h>

@interface ImageLazyLoadViewController : UIViewController
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
- (void)setupCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)setCellImageView:(UITableViewCell *)cell imageView:(UIImageView *)imageView andImageViewURL:(NSURL *)targetURL;
- (void)setImageDownLoadValue:(NSString *)value forHTTPHeaderField:(NSString *)headerFiled;
@end
