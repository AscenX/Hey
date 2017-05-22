//
//  ChatTableViewCell.h
//  Hey
//
//  Created by Ascen on 2017/4/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M80AttributedLabel/M80AttributedLabel.h"

extern NSString * const myselfCellId;

@interface ChatMyselfTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *iconButton;

@property (weak, nonatomic) IBOutlet M80AttributedLabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *tipsView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
