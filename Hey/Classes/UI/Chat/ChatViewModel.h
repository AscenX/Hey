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

- (instancetype)initWithUser:(User *)user;


@end
