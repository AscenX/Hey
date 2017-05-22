//
//  ContactsViewModel.m
//  Hey
//
//  Created by Ascen on 2017/5/20.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "ContactsViewModel.h"
#import "UserManager.h"
#import "Store.h"

@implementation ContactsViewModel

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (RACCommand *)fetchContactsCommand {
    if (!_fetchContactsCommand) {
        @weakify(self)
        _fetchContactsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            User *user = [Store sharedStore].userSignal.first;
            return [[[UserManager sharedManager] fetchContactsWithUserId:user.Id] doNext:^(id  _Nullable x) {
                @strongify(self)
                self.contacts = x;
            }];
        }];
    }
    return _fetchContactsCommand;
}

@end
