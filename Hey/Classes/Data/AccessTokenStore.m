//
//  AccessTokenStore.m
//  Hey
//
//  Created by Ascen on 2017/4/19.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "AccessTokenStore.h"
#import <UICKeyChainStore/UICKeyChainStore.h>

static NSString * const kAccessTokenKey = @"accessTokenHey";
static NSString * const kQiniuTokenKey = @"qiniuTokenHey";

@interface AccessTokenStore ()

@property (nonatomic, strong) UICKeyChainStore *keyChainStore;
@property (nonatomic, strong) NSUserDefaults *userDefaults;

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
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (NSString *)getAccessToken {
    NSString *token =  [self.keyChainStore stringForKey:kAccessTokenKey];
    if (!token) {
        token = [self.userDefaults objectForKey:kAccessTokenKey];
    }
    return token;
}

- (NSString *)getQiniuToken {
    NSString *token =  [self.keyChainStore stringForKey:kQiniuTokenKey];
    if (!token) {
        token = [self.userDefaults objectForKey:kQiniuTokenKey];
    }
    return token;
}

- (void)updateAccessToken:(NSString *)accessToken {
    [self.keyChainStore setString:accessToken forKey:kAccessTokenKey];
    [self.userDefaults setObject:accessToken forKey:kAccessTokenKey];
}

- (void)updateQiniuToken:(NSString *)qiniuToken {
    [self.keyChainStore setString:qiniuToken forKey:kAccessTokenKey];
    [self.userDefaults setObject:qiniuToken forKey:kAccessTokenKey];
}

- (void)clearToken {
    [self.keyChainStore removeItemForKey:kAccessTokenKey];
    [self.userDefaults removeObjectForKey:kAccessTokenKey];
    
    [self.keyChainStore removeItemForKey:kQiniuTokenKey];
    [self.userDefaults removeObjectForKey:kQiniuTokenKey];
}

@end
