//
//  UserInfoTableViewCell.h
//  Hey
//
//  Created by Ascen on 2017/5/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
