//
//  StatusTableViewCell.m
//  Hey
//
//  Created by Ascen on 2017/5/29.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "StatusTableViewCell.h"
#import "Status.h"
#import <YYWebImage/YYWebImage.h>
#import <UIView_FDCollapsibleConstraints/UIView+FDCollapsibleConstraints.h>
#import <SDAutoLayout/SDAutoLayout.h>

@implementation StatusTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupView {
    
}

- (void)setStatus:(Status *)status {
    _status = status;
    
    [_iconButton yy_setImageWithURL:[NSURL URLWithString:status.avatar] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"icon_avatar"]];
    
    [_nameButton setTitle:status.username forState:UIControlStateNormal];
    _timeLabel.text = status.time;
    
    _contentLabel.text = status.content;
    _contentLabel.sd_layout.autoHeightRatio(0);
    
    [_containerView clearAutoHeigtSettings];
    if ([status.imageURL isEqualToString:@""] || status.imageURL == nil) {
        _contentImageView.sd_layout.leftSpaceToView(self, 15).topEqualToView(_contentLabel).bottomEqualToView(_likeButton).widthIs(0).heightIs(0);
        _contentImageView.image = nil;
    }
    else {
        CGFloat w;
        CGFloat h;
        
        if (status.imageScale.floatValue > 1.0f) {
            w = self.bounds.size.width - 2 * 15;
            h = w / status.imageScale.floatValue;
        }
        else {
            h = 300;
            w = h * status.imageScale.floatValue;
        }
        _contentImageView.sd_layout.leftSpaceToView(self, 15).topEqualToView(_contentLabel).bottomEqualToView(_likeButton).widthIs(w).heightIs(h);
        [_contentImageView yy_setImageWithURL:[NSURL URLWithString:status.imageURL] placeholder:[UIImage imageNamed:@"icon_placeholder"]];
    
    }
    [_containerView setupAutoHeightWithBottomView:_commentButton bottomMargin:20];
}

@end
