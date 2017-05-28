//
//  ProfileTableViewCell.m
//  Hey
//
//  Created by Ascen on 2017/5/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "ProfileTableViewCell.h"

NSString * const kProfileTableViewCellId = @"kProfileTableViewCellId";

@implementation ProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    ProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProfileTableViewCellId];
    if (!cell) {
        cell = [[ProfileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kProfileTableViewCellId];
    }
    return cell;
}

@end
