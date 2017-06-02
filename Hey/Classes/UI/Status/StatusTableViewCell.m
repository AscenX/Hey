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
#import <SDAutoLayout/SDAutoLayout.h>
#import "UIColor+Help.h"
#import "DateTools/NSDate+DateTools.h"


@implementation StatusTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupView {
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    _containerView = [[UIView alloc] init];
    _containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_containerView];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0f];
    [_containerView addSubview:_lineView];
    
    _hlineView = [[UIView alloc] init];
    _hlineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0f];
    [_containerView addSubview:_hlineView];
    
    
    _iconButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 44, 44)];
    [_containerView addSubview:_iconButton];
    
    _nameButton = [[UIButton alloc] initWithFrame:CGRectMake(75, 15, 100, 25)];
    _nameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_nameButton setTitleColor:[UIColor colorWithWhite:0.5f alpha:1.0f] forState:UIControlStateNormal];
    _nameButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_containerView addSubview:_nameButton];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 45, [UIApplication sharedApplication].keyWindow.bounds.size.width - 90, 20)];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font = [UIFont systemFontOfSize:14.0f];
    _timeLabel.textColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    [_containerView addSubview:_timeLabel];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    [_containerView addSubview:_contentLabel];
    
    
    _commentButton = [[UIButton alloc] init];
    [_commentButton setTitle:@"评论" forState:UIControlStateNormal];
    [_commentButton setTitleColor:[UIColor colorWithWhite:0.5 alpha:1.0f] forState:UIControlStateNormal];
    _commentButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_containerView addSubview:_commentButton];
    
    _likeButton = [[UIButton alloc] init];
    [_likeButton setImage:[UIImage imageNamed:@"icon_like"] forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage imageNamed:@"icon_liked"] forState:UIControlStateSelected];
    [_likeButton setTitleColor:[UIColor colorWithHex:0x9B9B9B alpha:0.64f] forState:UIControlStateNormal];
    [_likeButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_containerView addSubview:_likeButton];
    
    _contentImageView = [[UIImageView alloc] init];
    [_containerView addSubview:_contentImageView];
}

- (void)setStatus:(Status *)status {
    _status = status;
    
    CGFloat width = [UIApplication sharedApplication].keyWindow.bounds.size.width;
    CGRect rect = [status.content boundingRectWithSize:CGSizeMake(width - 2 * 15, 500) options:NSStringDrawingUsesFontLeading attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    self.contentLabel.frame = CGRectMake(15, 75, width - 2 * 15, rect.size.height);
    
    CGFloat height = CGRectGetMaxY(self.contentLabel.frame);
    
    if ([status.imageURL isEqualToString:@""] || status.imageURL == nil) {
        self.contentImageView.hidden = YES;
        self.contentImageView.image = nil;
        self.lineView.frame = CGRectMake(15, height + 10, width - 30, 1);
        self.commentButton.frame = CGRectMake(0, height + 11, width / 2, 44);
        self.likeButton.frame = CGRectMake(width / 2 , height + 11, width / 2, 44);
        self.hlineView.frame = CGRectMake(width / 2, CGRectGetMaxY(self.lineView.frame) + 5, 1, 34);
        self.containerView.frame = CGRectMake(0, 0, width, CGRectGetMaxY(self.likeButton.frame));
    }
    else {
        self.contentImageView.hidden = NO;
        
        CGFloat w;
        CGFloat h;
        
        if (status.imageScale.floatValue >= 1.0f) {
            w = width - 2 * 15;
            h = w / status.imageScale.floatValue;
        }
        else {
            h = 300;
            w = h * status.imageScale.floatValue;
        }
        self.contentImageView.frame = CGRectMake(15, height + 15, w, h);
        [self.contentImageView yy_setImageWithURL:[NSURL URLWithString:status.imageURL] placeholder:[UIImage imageNamed:@"icon_placeholder"]];
        height = CGRectGetMaxY(self.contentImageView.frame);
        
        self.lineView.frame = CGRectMake(15, height + 10, width - 30, 1);
        
        self.commentButton.frame = CGRectMake(0, height + 11, width / 2, 44);
        self.likeButton.frame = CGRectMake(width / 2 , height + 11, width / 2, 44);
        self.hlineView.frame = CGRectMake(width / 2, CGRectGetMaxY(self.lineView.frame) + 5, 1, 34);
        self.containerView.frame = CGRectMake(0, 0, width, CGRectGetMaxY(self.commentButton.frame));
    }
    
    [_iconButton yy_setImageWithURL:[NSURL URLWithString:status.avatar] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"icon_avatar"]];
    [_nameButton setTitle:status.username forState:UIControlStateNormal];
    _timeLabel.text = status.time;
    _contentLabel.text = status.content;
    
    self.likeButton.selected = status.youLike;
    if (status.likeNum.integerValue == 0) {
        [self.likeButton setTitle:@"" forState:UIControlStateSelected];
        [self.likeButton setTitle:@"" forState:UIControlStateNormal];
    }
    else {
        [self.likeButton setTitle:[NSString stringWithFormat:@"%@", status.likeNum] forState:UIControlStateSelected];
        [self.likeButton setTitle:[NSString stringWithFormat:@"%@", status.likeNum] forState:UIControlStateNormal];
    }
    
    
}

@end
