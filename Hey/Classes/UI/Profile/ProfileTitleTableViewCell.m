//
//  ProfileTitleTableViewCell.m
//  Hey
//
//  Created by Ascen on 2017/5/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "ProfileTitleTableViewCell.h"

@implementation ProfileTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    ProfileTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileTitleTableViewCellID"];
    if (!cell) {
        cell = [[ProfileTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileTitleTableViewCellID"];
    }
    return cell;
}

@end
