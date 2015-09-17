//
//  LazyLoadCell.m
//  TeamKnowledgeBase
//
//  Created by wangtie on 15/9/15.
//  Copyright (c) 2015年 wangtie. All rights reserved.
//

#import "LazyLoadCell.h"
#import "Masonry.h"
@interface LazyLoadCell ()

@end

@implementation LazyLoadCell

- (UIImageView *)cellDetailView{
    if (_cellDetailView) {
        return _cellDetailView;
    }
    _cellDetailView = [[UIImageView alloc] init];
    return _cellDetailView;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.cellDetailView];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints{
    [super updateConstraints];
    [self.cellDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
