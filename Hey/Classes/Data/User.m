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
             @"iconURL" : @"IconURL",
             };
}

+ (NSDictionary *)FMDBColumnsByPropertyKey {
    return @{
             @"Id" : @"id",
             @"name" : @"username",
             @"iconURL" : @"icon_url",
             };
}

+ (NSString *)FMDBTableName {
    return @"t_users";
}

+ (NSArray *)FMDBPrimaryKeys {
    return @[@"id"];
}

@end
