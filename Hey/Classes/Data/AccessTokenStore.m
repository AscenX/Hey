//
//  AccessTokenStore.m
//  Hey
//
//  Created by Ascen on 2017/4/19.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "AccessTokenStore.h"
#import <UICKeyChainStore/UICKeyChainStore.h>

static NSString * const kTokenKey = @"accessTokenForHey";

@interface AccessTokenStore ()

@property (nonatomic, strong) UICKeyChainStore *keyChainStore;

@end

@implementation AccessTokenStore

+ (instancetype)sharedStore
{
    static AccessTokenStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] init];
    });
    return sharedStore;
}

- (instancetype)init {
    if (self = [super init]) {
        _keyChainStore = [UICKeyChainStore keyChainStoreWithService:@"com.ascen.hey"];
    }
    return self;
}

- (NSString *)getToken {
    NSString *token =  [self.keyChainStore stringForKey:kTokenKey];
    return token;
}

- (void)updateToken:(NSString *)token {
    [self.keyChainStore setString:token forKey:kTokenKey];
}

- (void)clearToken {
    [self.keyChainStore removeItemForKey:kTokenKey];
}

@end
