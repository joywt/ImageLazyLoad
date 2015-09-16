//
//  ImageLazyLoadViewController.m
//  TeamKnowledgeBase
//
//  Created by wangtie on 15/9/15.
//  Copyright (c) 2015年 wangtie. All rights reserved.
//

#import "ImageLazyLoadViewController.h"
#define LazyLoadImageViewKey @"LazyLoadImageViewKey"
#define LazyLoadImageURLKey @"LazyLoadImageURLKey"


@interface ImageLazyLoadViewController () <UITableViewDataSource,UITableViewDelegate>



@property (nonatomic,strong) NSValue *targetRect;
@property (nonatomic,strong) NSString *imageDownLoadValue;
@property (nonatomic,strong) NSString *headerFiled;
@end

@implementation ImageLazyLoadViewController

#pragma mark - property
-(UITableView *)tableView{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] init];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    return _tableView;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.targetRect = nil;
    [self loadImageForVisibleCells];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGRect targetRect = CGRectMake(targetContentOffset->x, targetContentOffset->y, scrollView.frame.size.width, scrollView.frame.size.height);
    self.targetRect = [NSValue valueWithCGRect:targetRect];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    self.targetRect = nil;
    [self loadImageForVisibleCells];
}
- (void)setImageDownLoadValue:(NSString *)value forHTTPHeaderField:(NSString *)headerFiled{
    self.imageDownLoadValue = value;
    self.headerFiled = headerFiled;
}
- (void)setupCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    SDWebImageDownloader *downloader = [[SDWebImageManager sharedManager] imageDownloader];
    [downloader setValue:self.imageDownLoadValue forHTTPHeaderField:self.headerFiled];
    
    UIImageView *cellImageView =  [self getCellImageView:cell];
    NSURL *targetURL = [self getTargetURL:cell];
    if (cellImageView && targetURL && ![[cellImageView sd_imageURL] isEqual:targetURL]) {
        cellImageView.alpha = 0.0;
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        CGRect cellFrame = [self.tableView rectForRowAtIndexPath:indexPath];
        BOOL shouldLoadImage = YES;
        if (self.targetRect && !CGRectIntersectsRect([self.targetRect CGRectValue], cellFrame)) {
            SDImageCache *cache = [manager imageCache];
            NSString *key = [manager cacheKeyForURL:targetURL];
            if (![cache imageFromMemoryCacheForKey:key]) {
                shouldLoadImage = NO;
            }
        }
        
        if (shouldLoadImage) {
            [cellImageView sd_setImageWithURL:targetURL placeholderImage:nil options:SDWebImageHandleCookies completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if ([imageURL isEqual:targetURL]) {
                    [UIView animateWithDuration:0.2 animations:^{
                        cellImageView.alpha = 1.0;
                    }];
                }
            }];
        }
        
    }

}
- (void)loadImageForVisibleCells{
    NSArray *cells = [self.tableView visibleCells];
    [cells enumerateObjectsUsingBlock:^(UITableViewCell *cell, NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self setupCell:cell cellForRowAtIndexPath:indexPath];
    }];
}

- (void)setCellImageView:(UITableViewCell *)cell imageView:(UIImageView *)imageView andImageViewURL:(NSURL *)targetURL{
    objc_setAssociatedObject(cell, LazyLoadImageViewKey, imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(cell, LazyLoadImageURLKey, targetURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIImageView *)getCellImageView:(UITableViewCell *)cell{
    return objc_getAssociatedObject(cell,LazyLoadImageViewKey);
}

- (NSURL *)getTargetURL:(UITableViewCell *)cell{
    return objc_getAssociatedObject(cell, LazyLoadImageURLKey);
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
