//
//  ChatSession.h
//  Hey
//
//  Created by Ascen on 2017/5/4.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

@class User;

@interface ChatSession : MTLModel <MTLJSONSerializing, MTLFMDBSerializing>

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *iconURL;
@property (nonatomic, copy) NSString *sessionName;
@property (nonatomic, copy) NSString *lastSentence;
@property (nonatomic, copy) NSString *time;

- (instancetype)initWithUser:(User *)user;

- (BOOL)isEqualToSession:(ChatSession *)session;

@end
