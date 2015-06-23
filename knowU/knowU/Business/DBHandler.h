//
//  DBHandler.h
//  DBHandlerLib
//
//  Created by Xiaobin Chen on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;

@interface DBHandler : NSObject

//绑定用户数据库，程序启动或者登录后调用
+ (void)setUserId:(NSString *)userId;

//返回根据当前用户生成的数据库跟目录
+ (NSString *)dbPathForCurrentUser;

+ (BOOL)beginDeferredTransaction;
+ (BOOL)commit;
+ (BOOL)rollback;
+ (FMDatabase *)getDB;
+ (FMDatabase *)prepareDatabase;

+ (void)run:(void (^)(void))completion;

@end
