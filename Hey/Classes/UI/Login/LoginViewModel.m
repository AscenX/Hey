//
//  LoginViewModel.m
//  Hey
//
//  Created by Ascen on 2017/4/22.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "LoginViewModel.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "UserManager.h"
#import "SIMPConnection.h"
#import "Constants.h"
#import "AccessTokenStore.h"
#import "User.h"
#import "Store.h"
#import "NSString+MD5.h"

@implementation LoginViewModel

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (RACCommand *)loginCommand {
    if (!_loginCommand) {
        _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @weakify(self)
            return [[[UserManager sharedManager] loginWithUserId:self.userId password:[NSString md5EncryptWithString:self.password]] map:^id(id value) {
                @strongify(self)
                BOOL success = [[SIMPConnection sharedConnection] connectionToRemoteHost:serverHost port:socketPort forUser:self.userId];
                return @(success);
            }];
        }];
    }
    return _loginCommand;
}

@end
