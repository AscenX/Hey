//
//  ChatSession.m
//  Hey
//
//  Created by Ascen on 2017/5/4.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "ChatSession.h"

@implementation ChatSession

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"Id" : @"identity",
             @"userIdsData" : @"user_ids",
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

- (NSArray *)userIds {
    return [NSKeyedUnarchiver unarchiveObjectWithData:_userIdsData];
}

- (void)setUserIds:(NSArray *)userIds {
    _userIdsData = [NSKeyedArchiver archivedDataWithRootObject:userIds];
}


@end
