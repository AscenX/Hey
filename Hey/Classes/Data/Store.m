//
//  Store.m
//  Hey
//
//  Created by Ascen on 2017/4/19.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "Store.h"
#import "AccessTokenStore.h"
#import "DBMigrationHelper.h"
#import <FMDB/FMDB.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

@interface Store ()

@property (nonatomic, strong) FMDatabase *db;

@property (nonatomic, strong) RACSubject *subject;

@end

@implementation Store

+ (instancetype)sharedStore {
    static dispatch_once_t onceToken;
    static Store *store;
    dispatch_once(&onceToken, ^{
        store = [[Store alloc] init];
    });
    return store;
}

- (instancetype)init {
    if (self = [super init]) {
        _subject = [RACSubject subject];
        _stateSignal = [[[[_subject scanWithStart:[self initialState] reduce:^State *(State *state, ReduceBlock reduceBlock) {
            return reduceBlock(state);
        }]
                          startWith:[self initialState]]
                         subscribeOn:[RACScheduler scheduler]]
                        replayLast];
        
        _viewerSignal = [[_stateSignal map:^id(State *state) {
            return state.viewer;
        }] distinctUntilChanged];
        
        _tokenSignal = [[_viewerSignal map:^id(Viewer *viewer) {
            return viewer.token;
        }] distinctUntilChanged];
        
        _userSignal = [[_viewerSignal map:^id(Viewer *viewer) {
            return viewer.user;
        }] distinctUntilChanged];
        
#ifdef DEBUG
        [_stateSignal subscribeNext:^(State *state) {
            NSError *error;
            NSDictionary *json = [MTLJSONAdapter JSONDictionaryFromModel:state error:&error];
            if (error) {
                NSLog(@"app state %@", error);
            } else {
                NSLog(@"app state = %@", json);
            }
        }];
#endif
    }
    return self;
}

#pragma mark - Update

- (void)updateState:(ReduceBlock)reduceBlock {
    [self.subject sendNext:reduceBlock];
}

- (void)updateViewer:(Viewer *)viewer {
    [self updateState:^State *(State *state) {
        return [State createWithState:state key:@"viewer" value:viewer];
    }];
}

- (void)updateUser:(User *)user {
    [self updateState:^State *(State *state) {
        Viewer *viewer = [Viewer createWithViewer:state.viewer key:@"user" value:user];
        [self persistViewer:viewer];
        return [State createWithState:state key:@"viewer" value:viewer];
    }];
}

- (void)updateUsername:(NSString *)username {
    [self updateState:^State *(State *state) {
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return [State createWithState:state key:@"username" value:username];
    }];
}

- (void)clearViewer {
    [self updateState:^State *(State *state) {
        [self persistViewer:nil];
        return [State createWithState:state key:@"viewer" value:nil];
    }];
}

#pragma mark - Init

- (void)persistViewer:(Viewer *)viewer {
    
    [self.db executeUpdate:@"DELETE FROM t_user"];
    [[AccessTokenStore sharedStore] clearToken];
    if (viewer.user) {
        NSString *insert = [MTLFMDBAdapter insertStatementForModel:viewer.user];
        [self.db executeUpdate:insert];
    }
    if (viewer.token) {
        [[AccessTokenStore sharedStore] updateToken:viewer.token];
    }
}

- (State *)initialState {
    Viewer *viewer = [self viewerFromDB];
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    return [[State alloc] initWithDictionary:@{
                                               @"viewer" : viewer ?: NSNull.null,
                                               @"username" : username ?: NSNull.null,
                                               } error:NULL];
}

- (Viewer *)viewerFromDB {
    NSString *token = [[AccessTokenStore sharedStore] getToken];
    if (!token) {
        return nil;
    }
    
    NSError *error;
    FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_user LIMIT 1"];
    User *user;
    if ([resultSet next]) {
        user = [MTLFMDBAdapter modelOfClass:[User class] fromFMResultSet:resultSet error:&error];
    }
    
    if (!user) {
        if (error) {
            NSLog(@"%@", error);
        }
        return nil;
    }
    
    Viewer *viewer = [[Viewer alloc] initWithDictionary:@{
                                                          @"token" : token,
                                                          @"user" : user, } error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    
    return viewer;
}

- (FMDatabase *)db {
    if (!_db) {
        _db = [DBMigrationHelper sharedInstance].database;
    }
    return _db;
}
@end
