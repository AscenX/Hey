//
//  ChatTableViewCell.h
//  Hey
//
//  Created by Ascen on 2017/5/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatRecord.h"
#import "MLEmojiLabel.h"

extern NSString *const kChatTableViewCellId;

@interface ChatTableViewCell : UITableViewCell

@property (nonatomic, strong) ChatRecord *chatRecord;

@property (nonatomic, copy) void (^didSelectLinkTextOperationBlock)(NSString *link, MLEmojiLabelLinkType type);

@property (nonatomic, strong) UIButton *iconButton;

@end
