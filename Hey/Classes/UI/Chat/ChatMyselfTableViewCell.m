//
//  ChatTableViewCell.m
//  Hey
//
//  Created by Ascen on 2017/4/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "ChatMyselfTableViewCell.h"
#import "UIColor+Help/UIColor+Help.h"

NSString * const myselfCellId = @"ChatMyselfTableViewCellId";

@implementation ChatMyselfTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithHex:0xF2F6FA alpha:0.77f];
    self.tipsView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    ChatMyselfTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myselfCellId];
    if (!cell) {
        cell = [[ChatMyselfTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:myselfCellId];
    }
    return cell;
}

@end
