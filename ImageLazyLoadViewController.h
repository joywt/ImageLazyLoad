//
//  ImageLazyLoadViewController.h
//  TeamKnowledgeBase
//
//  Created by wangtie on 15/9/15.
//  Copyright (c) 2015年 wangtie. All rights reserved.
//
//实现思路：
//1.当用户手动 drag table view 的时候，会加载 cell 中的图片；
//2.在用户快速滑动的减速过程中，不加载过程中 cell 中的图片（但文字信息还是会被加载，只是减少减速过程中的网络开销和图片加载的开销）；
//3.在减速结束后，加载所有可见 cell 的图片（如果需要的话）；

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import <objc/runtime.h>

@interface ImageLazyLoadViewController : UIViewController
@property (nonatomic,strong) UITableView *tableView;
/**
 *  设置 cell 里面的加载图片的视图和链接
 *
 *  @param cell      当前单元格
 *  @param imageView 加载图片的视图
 *  @param targetURL 图片链接
 */
- (void)setCellImageView:(UITableViewCell *)cell imageView:(UIImageView *)imageView andImageViewURL:(NSURL *)targetURL;
/**
 *  加载 cell 的图片数据
 *
 *  @param cell      当前单元格
 *  @param indexPath 单元格所在引索
 */
- (void)setupCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 *  设置图片下载的 headerField
 *
 *  @param value       headerField 的值
 *  @param headerFiled headerField 的名称
 */
- (void)setImageDownLoadValue:(NSString *)value forHTTPHeaderField:(NSString *)headerFiled;
/**
 *  设置默认图片
 *
 *  @param image 图片
 */
- (void)setImageViewPlaceholderImage:(UIImage *)image;
@end
