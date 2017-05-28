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
    static Store *store = nil;
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
            return viewer.accessToken;
        }] distinctUntilChanged];
        
        _userSignal = [[_viewerSignal map:^id(Viewer *viewer) {
            return viewer.user;
        }] distinctUntilChanged];
        
        _chatRecordSignal = [[_viewerSignal map:^id(Viewer *viewer) {
            return viewer.chatRecords;
        }] distinctUntilChanged];
        
        _chatSessionSignal = [[_viewerSignal map:^id(Viewer *viewer) {
            return viewer.chatSessions;
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

- (void)updateAccessToken:(NSString *)accessToken {
    [self updateState:^State *(State *state) {
        Viewer *viewer = [Viewer createWithViewer:state.viewer key:@"accessToken" value:accessToken];
        [self persistViewer:viewer];
        return [State createWithState:state key:@"viewer" value:viewer];
    }];
}

- (void)updateQiniuToken:(NSString *)qiniuToken {
    [self updateState:^State *(State *state) {
        Viewer *viewer = [Viewer createWithViewer:state.viewer key:@"qiniuToken" value:qiniuToken];
        [self persistViewer:viewer];
        return [State createWithState:state key:@"viewer" value:viewer];
    }];
}

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

- (void)updateSessions:(NSArray *)sessions {
    [self updateState:^State *(State *state) {
        Viewer *viewer = [Viewer createWithViewer:state.viewer key:@"chatSessions" value:sessions];
        [self persistViewer:viewer];
        return [State createWithState:state key:@"viewer" value:viewer];
    }];
}

- (void)updateChatRecords:(NSArray *)chatRecords {
    [self updateState:^State *(State *state) {
        Viewer *viewer = [Viewer createWithViewer:state.viewer key:@"chatRecords" value:chatRecords];
        [self persistViewer:viewer];
        return [State createWithState:state key:@"viewer" value:viewer];
    }];
}

- (void)updateContacts:(NSArray *)contacts {
    [self updateState:^State *(State *state) {
        Viewer *viewer = [Viewer createWithViewer:state.viewer key:@"contacts" value:contacts];
        [self persistViewer:viewer];
        return [State createWithState:state key:@"viewer" value:viewer];
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
    
    [self.db executeUpdate:@"DELETE FROM t_users"];
    [self.db executeUpdate:@"DELETE FROM t_contacts"];
    [self.db executeUpdate:@"DELETE FROM t_chat_records"];
    [self.db executeUpdate:@"DELETE FROM t_chat_sessions"];
    [[AccessTokenStore sharedStore] clearToken];
    
    if (viewer.user) {
        NSString *insertUser = @"insert into t_users (identity, avatar, name) values (?, ?, ?)";
        [self.db executeUpdate:insertUser, viewer.user.Id, viewer.user.avatar, viewer.user.name];
    }
    
    if (viewer.contacts) {
        NSString *insertContacts = @"insert into t_contacts (identity, name, avatar) values (?, ?, ?)";
        for (int i = 0; i < viewer.contacts.count; ++i) {
            Contact *contact = viewer.contacts[i];
            [self.db executeUpdate:insertContacts, contact.Id, contact.name, contact.avatar];
        }
    }
    
    if (viewer.chatRecords) {
        NSString *insertChatRecords = @"insert into t_chat_records (identity, type, time, from_user_id, to_user_id, content, image_url, image_scale) values (?, ?, ?, ?, ?, ?, ?, ?)";
        for (int i = 0; i < viewer.chatRecords.count; ++i) {
            ChatRecord *chatRecord = viewer.chatRecords[i];
            [self.db executeUpdate:insertChatRecords, chatRecord.Id, chatRecord.type, chatRecord.time, chatRecord.fromUserId, chatRecord.toUserId, chatRecord.content, chatRecord.imageURL, chatRecord.imageScale];
        }
    }
    
    if (viewer.chatSessions) {
        NSString *insertChatSessions = @"insert into t_chat_sessions (identity, username, image_url, session_name, last_sentence, time) values (?, ?, ?, ?, ?, ?)";

        for (int i = 0; i < viewer.chatSessions.count; ++i) {
            ChatSession *session = viewer.chatSessions[i];
            [self.db executeUpdate:insertChatSessions, session.userId, session.username, session.iconURL, session.sessionName, session.lastSentence, session.time];
        }
    }
    
    if (viewer.accessToken) {
        [[AccessTokenStore sharedStore] updateAccessToken:viewer.accessToken];
    }
    if (viewer.qiniuToken) {
        [[AccessTokenStore sharedStore] updateQiniuToken:viewer.qiniuToken];
    }
}

- (State *)initialState {
    Viewer *viewer = [self viewerFromDB];
    return [[State alloc] initWithDictionary:@{
                                               @"viewer" : viewer ?: NSNull.null,
                                               } error:NULL];
}

- (Viewer *)viewerFromDB {
    NSString *accessToken = [[AccessTokenStore sharedStore] getAccessToken];
    if (!accessToken) {
        return nil;
    }
    
    NSString *qiniuToken = [[AccessTokenStore sharedStore] getQiniuToken];
    
    NSError *error;
    FMResultSet *userResultSet = [self.db executeQuery:@"SELECT * FROM t_users LIMIT 1"];
    User *user;
    if ([userResultSet next]) {
        user = [MTLFMDBAdapter modelOfClass:[User class] fromFMResultSet:userResultSet error:&error];
    }
    
    if (!user) {
        if (error) {
            NSLog(@"user--%@", error);
        }
        return nil;
    }
    
    FMResultSet *contactsResultSet = [self.db executeQuery:@"SELECT * FROM t_contacts"];
    NSMutableArray *contacts = [NSMutableArray array];
    while ([contactsResultSet next]) {
        
        Contact *contact = [MTLFMDBAdapter modelOfClass:[Contact class] fromFMResultSet:contactsResultSet error:&error];
        if (contact) {
            [contacts addObject:contact];
        }
    }
    
    if (contacts.count == 0) {
        if (error) {
            NSLog(@"contacts--%@", error);
        }
    }
    
    FMResultSet *chatRecordsResultSet = [self.db executeQuery:@"SELECT * FROM t_chat_records"];
    NSMutableArray *chatRecords = [NSMutableArray array];
    while ([chatRecordsResultSet next]) {
        ChatRecord *chatRecord = [MTLFMDBAdapter modelOfClass:[ChatRecord class] fromFMResultSet:chatRecordsResultSet error:&error];
        if (chatRecord) {
            [chatRecords addObject:chatRecord];
        }
    }
    
    if (chatRecords.count == 0) {
        if (error) {
            NSLog(@"chatRecords--%@", error);
        }
    }
    
    FMResultSet *chatSessionsResultSet = [self.db executeQuery:@"SELECT * FROM t_chat_sessions"];
    NSMutableArray *chatSessions = [NSMutableArray array];
    while ([chatSessionsResultSet next]) {
        ChatSession *chatSession = [MTLFMDBAdapter modelOfClass:[ChatSession class] fromFMResultSet:chatSessionsResultSet error:&error];
        if (chatSession) {
            [chatSessions addObject:chatSession];
        }
    }
    
    if (chatSessions.count == 0) {
        if (error) {
            NSLog(@"chatSessions--%@", error);
        }
    }
    
    Viewer *viewer = [[Viewer alloc] initWithDictionary:@{
                                                          @"accessToken" : accessToken ?:NSNull.null,
                                                          @"qiniuToken" : qiniuToken ?:NSNull.null,
                                                          @"user" : user ?:NSNull.null,
                                                          @"contacts" : [contacts copy]?:NSNull.null,
                                                          @"chatRecords" : [chatRecords copy] ?:NSNull.null,
                                                          @"chatSessions" :
                                                    [chatSessions copy]?:NSNull.null,
                                                          } error:&error];
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
