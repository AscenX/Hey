//
//  Store.h
//  Hey
//
//  Created by Ascen on 2017/4/19.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "User.h"
#import "State.h"
#import "Viewer.h"

typedef State*(^ReduceBlock)(State *state);

@interface Store : NSObject

+ (instancetype)sharedStore;

@property (nonatomic, strong, readonly) RACSignal *stateSignal;
@property (nonatomic, strong, readonly) RACSignal *viewerSignal;

@property (nonatomic, strong, readonly) RACSignal *tokenSignal;
@property (nonatomic, strong, readonly) RACSignal *userSignal;

@property (nonatomic, strong) RACSignal *chatRecordSignal;
@property (nonatomic, strong) RACSignal *chatSessionSignal;

- (void)updateState:(ReduceBlock)reduceBlock;

- (void)updateViewer:(Viewer *)viewer;

- (void)updateUser:(User *)user;

- (void)updateAccessToken:(NSString *)accessToken;

- (void)updateQiniuToken:(NSString *)qiniuToken;

- (void)updateSessions:(NSArray *)sessions;

- (void)updateChatRecords:(NSArray *)chatRecords;

- (void)updateContacts:(NSArray *)contacts;

- (void)clearViewer;

@end
