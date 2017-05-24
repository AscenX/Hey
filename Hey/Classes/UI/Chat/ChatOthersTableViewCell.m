//
//  ChatOthersTableViewCell.m
//  Hey
//
//  Created by Ascen on 2017/4/24.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "ChatOthersTableViewCell.h"

NSString * const othersCellId = @"ChatOthersTableViewCellId";

@implementation ChatOthersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    ChatOthersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:othersCellId];
    if (!cell) {
        cell = [[ChatOthersTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:othersCellId];
    }
    return cell;
}

@end
