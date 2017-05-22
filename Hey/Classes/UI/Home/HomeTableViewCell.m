//
//  HomeTableViewCell.m
//  Hey
//
//  Created by Ascen on 2017/1/14.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCellID"];
    if (!cell) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HomeTableViewCellID"];
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
