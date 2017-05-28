//
//  ChatSession.m
//  Hey
//
//  Created by Ascen on 2017/5/4.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "ChatSession.h"
#import "User.h"
#import <DateTools/NSDate+DateTools.h>

@implementation ChatSession

- (instancetype)initWithUser:(User *)user {
    if (self = [super init]) {
        _userId = user.Id;
        _username = user.name;
        _sessionName = user.name;
        _iconURL = user.avatar;
        _lastSentence = nil;
        if ([[NSDate date] formattedDateWithFormat:@"MM"].integerValue > 9) {
            _time = [[NSDate date] formattedDateWithFormat:@"MM月dd日 HH:mm"];
        }
        else {
            _time = [[NSDate date] formattedDateWithFormat:@"M月dd日 HH:mm"];
        }
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userId" : @"identity",
             @"userName" : @"username",
             @"sessionName" : @"session_name",
             @"imageURL" : @"image_url",
             @"lastSentence" : @"last_sentence",
             @"time" : @"time",
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"userId" : @"identity",
             @"userName" : @"username",
             @"sessionName" : @"session_name",
             @"imageURL" : @"image_url",
             @"lastSentence" : @"last_sentence",
             @"time" : @"time",
             };
}

+ (NSString *)FMDBTableName {
    return @"t_chat_sessions";
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"identity"];
}

- (BOOL)isEqualToSession:(ChatSession *)session {
    return self.userId.integerValue == session.userId.integerValue;
}

@end
