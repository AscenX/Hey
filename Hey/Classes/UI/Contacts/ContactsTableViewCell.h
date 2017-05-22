//
//  ContactsTableViewCell.h
//  Hey
//
//  Created by Ascen on 2017/5/22.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
