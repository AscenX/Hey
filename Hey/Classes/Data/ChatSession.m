//
//  ChatSession.m
//  Hey
//
//  Created by Ascen on 2017/5/4.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "ChatSession.h"

@implementation ChatSession

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"Id" : @"identity",
             @"userIdsData" : @"user_ids",
             @"userName" : @"username",
             @"sessionName" : @"session_name",
             @"imageURL" : @"image_url",
             @"lastSentence" : @"last_sentence",
             @"time" : @"created_at",
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"Id" : @"identity",
             @"userIdsData" : @"user_ids",
             @"userName" : @"username",
             @"sessionName" : @"session_name",
             @"imageURL" : @"image_url",
             @"lastSentence" : @"last_sentence",
             @"time" : @"created_at",
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

+ (NSDateFormatter *)dateFormatter {
    static dispatch_once_t onceToken;
    static NSDateFormatter *dateFormatter;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSSSSS+Z";
    });
    return dateFormatter;
}

+ (NSValueTransformer *)timeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        return [[self dateFormatter] dateFromString:value];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[self dateFormatter] stringFromDate:date];
    }];
}

@end
