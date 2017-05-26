//
//  ChatViewModel.h
//  Hey
//
//  Created by Ascen on 2017/4/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACCommand;
@class User;

@interface ChatViewModel : NSObject

@property (nonatomic, copy) NSMutableArray *chatRecords;

@property (nonatomic, strong, readonly) User *user;

- (instancetype)initWithUser:(User *)user;


@end
