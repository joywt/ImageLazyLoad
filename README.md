# ImageLazyLoad
### 列表图片加载优化
#### 实现思路：

1. 当用户手动 drag table view 的时候，会加载 cell 中的图片；
2. 在用户快速滑动的减速过程中，不加载过程中 cell 中的图片（但文字信息还是会被加载，只是减少减速过程中的网络开销和图片加载的开销）；
3. 在减速结束后，加载所有可见 cell 的图片（如果需要的话）；

#### 如何接入
1. 使用 pod 添加 `SDWebImage`,或者添加 SDWebImage 源码包。

	```
	pod 'SDWebImage'
	```
2. 下载 ImageLazyLoad 源码，然后拷贝里面的`ImageLazyLoadViewController.h` 和 `ImageLazyLoadViewController.m`文件。

#### 修改动画效果

实例采用的动画效果是简单的渐显，如需修改动画效果可修改 `ImageLazyLoadViewController.m`文件 中的 `- (void)setupCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath `方法，源代码如下：

	```
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
            [cellImageView sd_setImageWithURL:targetURL placeholderImage:self.defaultImage options:SDWebImageHandleCookies completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if ([imageURL isEqual:targetURL]) {
                    [UIView animateWithDuration:0.3 animations:^{
                        cellImageView.alpha = 1.0;
                    }];
                }
            }];
        }
        
    }

	```