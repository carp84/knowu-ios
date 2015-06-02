//
//  KUProfile.h
//  knowU
//
//  Created by HanJiatong on 15/5/18.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KUProfile : NSObject

+ (instancetype)manager;

- (NSDictionary *)readFile;

- (void)updateFileWithDay:(int)day;

@end
