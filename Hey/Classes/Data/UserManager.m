//
//  UserManager.m
//  Hey
//
//  Created by Ascen on 2017/4/21.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "UserManager.h"
#import "RestClient+User.h"
#import "Store.h"
#import "AccessTokenStore.h"
#import "Contact.h"
#import "User.h"

@implementation UserManager

//singleton
+ (instancetype)sharedManager
{
    static UserManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (RACSignal *)loginWithUserId:(NSString *)userId password:(NSString *)password {
    return [[[RestClient sharedClient] loginWithUserId:userId password:password] doNext:^(id  _Nullable x) {
        NSString *token = [x objectForKey:@"token"];
        [[Store sharedStore] updateAccessToken:token];
        NSDictionary *userDict = [x objectForKey:@"user"];
        User *user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:userDict error:nil];
        [[Store sharedStore] updateUser:user];
    }];
}

- (RACSignal *)fetchContactsWithUserId:(NSString *)userId {
    return [[[RestClient sharedClient] contactsWithUserId:userId] doNext:^(id  _Nullable x) {
        [[Store sharedStore] updateContacts:x];
    }];
}

- (User *)getUserById:(NSNumber *)userId {
    Viewer *viewer = [[Store sharedStore].viewerSignal first];
    NSArray *contacts = viewer.contacts;
    User *user = [[User alloc] init];
    for (int i = 0; i < contacts.count; ++i) {
        Contact *contact = contacts[i];
        if (contact.Id.integerValue == userId.integerValue) {
            user.Id = contact.Id;
            user.name = contact.name;
            user.avatar = contact.avatar;
        }
    }
    return user;
}

@end
