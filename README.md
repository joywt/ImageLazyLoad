# ImageLazyLoad
### 列表图片加载优化
#### 实现思路：

1. 当用户手动 drag table view 的时候，会加载 cell 中的图片；
2. 在用户快速滑动的减速过程中，不加载过程中 cell 中的图片（但文字信息还是会被加载，只是减少减速过程中的网络开销和图片加载的开销）；
3. 在减速结束后，加载所有可见 cell 的图片（如果需要的话）；

#### 如何接入
1. 使用 pod

	```
	pod 'SDWebImage'
	pod 'ImageLazyLoad'
	```
2. 下载demo，然后拷贝里面的`ImageLazyLoadViewController.h` 和 `ImageLazyLoadViewController.m`文件。