//
//  DBMigrationHelper.m
//  Hey
//
//  Created by Ascen on 2017/5/22.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <FMDBMigrationManager/FMDBMigrationManager.h>
#import "DBMigrationHelper.h"

static NSString * const DATABASE_NAME = @"hey.sqlite";

@interface DBMigrationHelper ()

@property (nonatomic, strong) FMDBMigrationManager *migrationManager;

@end

@implementation DBMigrationHelper

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static DBMigrationHelper *instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dir = [paths objectAtIndex:0];
        NSString *dbPath = [dir stringByAppendingPathComponent:DATABASE_NAME];
        _migrationManager = [FMDBMigrationManager managerWithDatabaseAtPath:dbPath migrationsBundle:[NSBundle mainBundle]];
    }
    return self;
}

- (void)setup {
    FMDBMigrationManager *manager = self.migrationManager;
    manager.dynamicMigrationsEnabled = NO;
    
#if DEBUG
    NSLog(@"Has `schema_migrations` table?: %@", manager.hasMigrationsTable ? @"YES" : @"NO");
    NSLog(@"Origin Version: %llu", manager.originVersion);
    NSLog(@"Current version: %llu", manager.currentVersion);
    NSLog(@"All migrations: %@", manager.migrations);
    NSLog(@"Applied versions: %@", manager.appliedVersions);
    NSLog(@"Pending versions: %@", manager.pendingVersions);
#endif
    
    NSError *error = nil;
    if (![manager hasMigrationsTable]) {
        BOOL success =[manager createMigrationsTable:&error];
        if (!success && error) {
#if DEBUG
            @throw [NSException exceptionWithName:error.domain reason:error.userInfo[NSLocalizedDescriptionKey] userInfo:error.userInfo];
#endif
        }
    }
    
    if ([manager needsMigration]) {
        BOOL success = [manager migrateDatabaseToVersion:UINT64_MAX progress:nil error:&error];
        if (!success && error) {
#if DEBUG
            @throw [NSException exceptionWithName:error.domain reason:error.userInfo[NSLocalizedDescriptionKey] userInfo:error.userInfo];
#endif
        }
    }
}

- (FMDatabase *)database {
    return self.migrationManager.database;
}


@end

