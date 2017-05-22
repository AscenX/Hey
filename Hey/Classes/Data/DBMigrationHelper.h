//
//  DBMigrationHelper.h
//  Hey
//
//  Created by Ascen on 2017/5/22.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;

@interface DBMigrationHelper : NSObject

+ (instancetype)sharedInstance;

- (void)setup;

- (FMDatabase *)database;

@end

