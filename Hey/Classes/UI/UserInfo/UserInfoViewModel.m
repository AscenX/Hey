//
//  UserInfoViewModel.m
//  Hey
//
//  Created by Ascen on 2017/5/23.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "UserInfoViewModel.h"
#import "User.h"

@interface UserInfoViewModel ()

@property (nonatomic, strong, readwrite) User *user;

@end

@implementation UserInfoViewModel

- (instancetype)initWithUser:(User *)user {
    if (self = [super init]) {
        _user = user;
    }
    return self;
}

- (NSArray *)statusImages {
    return @[
             @"http://7xsnb0.com1.z0.glb.clouddn.com/2017-05-22-stan.png",
             @"http://7xsnb0.com1.z0.glb.clouddn.com/2017-05-22-stan.png",
             @"http://7xsnb0.com1.z0.glb.clouddn.com/2017-05-22-stan.png",
             @"http://7xsnb0.com1.z0.glb.clouddn.com/2017-05-22-stan.png",
             ];
}

- (NSString *)imageURL {
    return self.user.avatar;
}

- (NSString *)name {
    return self.user.name;
}

- (NSString *)userId {
    return [NSString stringWithFormat:@"帐号: %@",self.user.Id];
}

@end
