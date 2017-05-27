//
//  ContactsTableViewCell.m
//  Hey
//
//  Created by Ascen on 2017/5/22.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "ContactsTableViewCell.h"

@implementation ContactsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    ContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsTableViewCellID"];
    if (!cell) {
        cell = [[ContactsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContactsTableViewCellID"];
    }
    return cell;
}

@end
