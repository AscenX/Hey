//
//  RestClient+User.h
//  Hey
//
//  Created by Ascen on 2017/4/21.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "RestClient.h"

@interface RestClient (User)

- (RACSignal *)loginWithUserId:(NSString *)userId password:(NSString *)password;

- (RACSignal *)contactsWithUserId:(NSString *)userId;

@end
