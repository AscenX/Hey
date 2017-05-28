//
//  HomeTableViewCell.h
//  Hey
//
//  Created by Ascen on 2017/1/14.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kSessionTableViewCellId;

@interface SessionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastSentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
