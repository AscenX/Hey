//
//  StatusTableViewCell.h
//  Hey
//
//  Created by Ascen on 2017/5/29.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Status;

@interface StatusTableViewCell : UITableViewCell

@property (nonatomic, strong) Status *status;
    
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, strong) UIButton *nameButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *hlineView;

@end
