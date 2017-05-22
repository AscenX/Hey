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
             @"token" :         @"token",
             @"user" :          @"user",
             };
}

+ (NSValueTransformer *)userJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[User class]];
}

@end
