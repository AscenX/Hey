//
//  Viewer.m
//  Hey
//
//  Created by Ascen on 2017/4/19.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "Viewer.h"

@interface Viewer ()

@property (nonatomic, strong, readwrite) User *user;
@property (nonatomic, copy, readwrite) NSString *token;
@property (nonatomic, copy, readwrite) NSArray *sessions;
@property (nonatomic, copy, readwrite) NSArray *chatRecords;

@end

@implementation Viewer


+ (instancetype)createWithViewer:(Viewer *)old key:(NSString *)key value:(id)value {
    Viewer *viewer = [[self alloc] init];
    if (old != nil) {
        [viewer mergeValuesForKeysFromModel:old];
    }
    [viewer setValue:value forKey:key];
    return viewer;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"accessToken" :         @"accessToken",
             @"qiniuToken" :         @"qiniuToken",
             @"user" :          @"user",
             @"chatSessions" : @"chatSessions",
             @"chatRecords" : @"chatRecords",
             @"contacts" : @"contacts",
             };
}

+ (NSValueTransformer *)userJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[User class]];
}

+ (NSValueTransformer *)sessionsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ChatSession class]];
}

+ (NSValueTransformer *)chatRecordsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ChatRecord class]];
}

+ (NSValueTransformer *)contactsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Contact class]];
}

@end
