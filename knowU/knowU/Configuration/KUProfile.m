//
//  KUProfile.m
//  knowU
//
//  Created by HanJiatong on 15/5/18.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "KUProfile.h"
#import "NSDate+Addition.h"

static KUProfile *profile;

@interface KUProfile ()

@property (nonatomic, copy) NSString *filePath;

@end

@implementation KUProfile
+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        profile = [[KUProfile alloc] init];
    });
    return profile;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.filePath = [path stringByAppendingPathComponent:@"knowU.plist"];
        if (![self readFile].count) {
            NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
            //初始化登录天数
            [self writeFileWithInitialValue:@{@"loginDay" : @1, @"totalLoginDay" : @1, @"loginDate" : @(interval)}];
        }
    }
    return self;
}

- (NSDictionary *)readFile{
    return [NSDictionary dictionaryWithContentsOfFile:self.filePath];
}

- (void)updateFile{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[self readFile]];
    NSNumber *totalLoginDay = [dictionary objectForKey:@"totalLoginDay"];
    totalLoginDay = [NSNumber numberWithInteger:totalLoginDay.integerValue + 1];
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    //如果登录是昨天，那么连续登录的天数加1
    if ([NSDate dateIsYesterdayWithInterval:interval]) {
        NSNumber *loginDay = [dictionary objectForKey:@"loginDay"];
        loginDay = [NSNumber numberWithInteger:loginDay.integerValue + 1];
        [dictionary setObject:loginDay forKey:@"loginDay"];
    }
    [dictionary setObject:totalLoginDay forKey:@"totalLoginDay"];
    [dictionary setObject:@(interval) forKey:@"loginDate"];
    [dictionary writeToFile:self.filePath atomically:YES];
    
}

#pragma mark- 写入初试值
- (void)writeFileWithInitialValue:(NSDictionary *)dictionary{
    [dictionary writeToFile:self.filePath atomically:YES];
    
}
@end