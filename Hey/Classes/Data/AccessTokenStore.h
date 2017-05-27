//
//  AccessTokenStore.h
//  Hey
//
//  Created by Ascen on 2017/4/19.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessTokenStore : NSObject

+ (instancetype)sharedStore;

- (NSString *)getAccessToken;

- (NSString *)getQiniuToken;

- (void)updateAccessToken:(NSString *)accessToken;

- (void)updateQiniuToken:(NSString *)qiniuToken;

- (void)clearToken;

@end
