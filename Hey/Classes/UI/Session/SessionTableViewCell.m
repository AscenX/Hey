//
//  HomeTableViewCell.m
//  Hey
//
//  Created by Ascen on 2017/1/14.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "SessionTableViewCell.h"

NSString * const kSessionTableViewCellId = @"SessionTableViewCellId";

@implementation SessionTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    SessionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSessionTableViewCellId];
    if (!cell) {
        cell = [[SessionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSessionTableViewCellId];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
