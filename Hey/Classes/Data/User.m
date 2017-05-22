//
//  User.m
//  Hey
//
//  Created by Ascen on 2017/5/20.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "User.h"

@implementation User

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"Id" : @"UserId",
             @"name" : @"UserName",
             @"avatar" : @"Avatar",
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"Id" : @"identity",
             @"name" : @"name",
             @"avatar" : @"avatar",
             };
}

+ (NSString *)FMDBTableName {
    return @"t_users";
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"identity"];
}

@end
