//
//  DBHandler.m
//  DBHandlerLib
//
//  Created by Xiaobin Chen on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DBHandler.h"
#import "FMDatabase.h"

#define MULTIPLE_PLAN_ENABLE 0

static FMDatabase *db;
static dispatch_queue_t dbqueue;

@implementation DBHandler

#pragma mark - class init and setup

+ (void)resetDB {
	[self run: ^{
	    [db close];
	    db = nil;
	}];
}

+ (NSString *)dbPathForCurrentUser {
	NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return documentsDir;
}

#pragma mark - DB

+ (BOOL)beginDeferredTransaction {
	__block BOOL rel = NO;
	[self run: ^{
	    FMDatabase *db = [self getDB];
	    rel = [db beginDeferredTransaction];
	}];
	return rel;
}

+ (BOOL)commit {
	__block BOOL rel = NO;
	[self run: ^{
	    FMDatabase *db = [self getDB];
	    rel = [db commit];
	}];
	return rel;
}

+ (BOOL)rollback {
	__block BOOL rel = NO;
	[self run: ^{
	    FMDatabase *db = [self getDB];
	    rel = [db rollback];
	}];
	return rel;
}

+ (void)run:(void (^)(void))completion {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    dbqueue = dispatch_queue_create("dbqueue", DISPATCH_QUEUE_SERIAL);
	});

	dispatch_sync(dbqueue, ^{
	    completion();
	});
}

+ (FMDatabase *)getDB {
	if (!db) {
		db = [self prepareDatabase];
	}
	return db;
}

// ready user数据库, 其后所有的数据库操作对象即是针对user的数据库。
+ (FMDatabase *)prepareDatabase {
	NSString *dbfileDir = [DBHandler dbPathForCurrentUser];

	NSString *dbfilePath = [dbfileDir stringByAppendingPathComponent:[NSString stringWithFormat:@"knowu.sqlite"]];

	FMDatabase *_fmdb = [FMDatabase databaseWithPath:dbfilePath];

	if (![_fmdb open]) {
		[_fmdb close];
        return nil;
    }
    NSString *msgTableCreateSql = @"create table if not exists `location` (`id` integer primary key autoincrement, `userId` text not null,`latitude` text not null, `longitude` text not null, `timestamp` text not null, `address` text, `action` text,`dayOfWeek` integer, `otherDescription` text, `isUpload` integer default 0, `ctime` timestamp not null default CURRENT_TIMESTAMP)";
    
    [_fmdb executeUpdate:msgTableCreateSql];
    
	return _fmdb;
}

@end
