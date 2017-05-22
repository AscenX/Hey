//
//  State.m
//  Hey
//
//  Created by Ascen on 2017/4/19.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "State.h"

@interface State ()

@property (nonatomic, strong, readwrite) Viewer *viewer;

@end

@implementation State

+ (instancetype)createWithState:(State *)old key:(NSString *)key value:(id)value {
    State *state = [[self alloc] init];
    if (old != nil) {
        [state mergeValuesForKeysFromModel:old];
    }
    [state setValue:value forKey:key];
    return state;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"viewer" : @"viewer",
             };
}

+ (NSValueTransformer *)viewerJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Viewer class]];
}

@end
