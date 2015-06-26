//
//  KULocationDAO.m
//  knowU
//
//  Created by HanJiatong on 15/6/23.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "KULocationDAO.h"
#import "KULocationModel.h"
#import "DBHandler.h"
#import "FMDB.h"

@implementation KULocationDAO
//create table if not exists `location` (`id` integer primary key autoincrement, `userId` text not null,`latitude` text not null, `longitude` text not null, `timestamp` text not null, `address` text, `action` text,`dayOfWeek` text, `otherDescription` text, `ctime` timestamp)
+ (BOOL)insertWithModel:(KULocationModel *)model{
    __block BOOL rel = NO;
    [DBHandler run:^{
        FMDatabase *db = [DBHandler getDB];
        rel = [db executeUpdate:@"insert into location (userId, latitude, longitude, timestamp, address, action, dayOfWeek, otherDescription) values (?, ?, ?, ?, ?, ?, ?, ?)", model.userId, model.latitude, model.longitude, model.timestamp, model.address, model.action, model.dayOfWeek, model.otherDescription];
    }];
    return rel;
}

+ (NSArray *)selectNotUpload{
    __block NSMutableArray *array = [[NSMutableArray alloc] init];
    [DBHandler run:^{
        FMDatabase *db = [DBHandler getDB];
        FMResultSet *rs = [db executeQuery:@"select * from location where isUpload = 0" withArgumentsInArray:@[]];
        while ([rs next]) {
            [array addObject:[self convertLocationModel:rs]];
        }
    }];
    return array;
}

+ (KULocationModel *)convertLocationModel:(FMResultSet *)rs{
    KULocationModel *model = [[KULocationModel alloc] init];
    model.userId = [rs stringForColumn:@"userId"];
    model.latitude = @([rs doubleForColumn:@"latitude"]);
    model.longitude = @([rs doubleForColumn:@"longitude"]);
    model.timestamp = [rs stringForColumn:@"timestamp"];
    model.address = [rs stringForColumn:@"address"];
    model.action = [rs stringForColumn:@"action"];
    model.dayOfWeek = @([rs intForColumn:@"dayOfWeek"]);
    model.otherDescription = [rs stringForColumn:@"otherDescription"];
    model.index = [rs intForColumn:@"id"];
    return model;
}

+ (BOOL)updateWithIndex:(NSNumber *)index{
    __block BOOL rel = NO;
    [DBHandler run:^{
        FMDatabase *db = [DBHandler getDB];
        rel = [db executeUpdate:@"update location set isUpload = 1 where id = ?", index];
    }];
    return rel;
}

+ (BOOL)deleteWithIndex:(NSNumber *)index{
    __block BOOL rel = NO;
    [DBHandler run:^{
        FMDatabase *db = [DBHandler getDB];
        rel = [db executeUpdate:@"delete from location where id = ?", index];
    }];
    return rel;
}
@end
