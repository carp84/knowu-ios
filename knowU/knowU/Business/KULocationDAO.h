//
//  KULocationDAO.h
//  knowU
//
//  Created by HanJiatong on 15/6/23.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KULocationModel;

@interface KULocationDAO : NSObject

+ (BOOL)insertWithModel:(KULocationModel *)model;

+ (NSArray *)selectNotUpload;

+ (BOOL)updateWithIndex:(NSNumber *)index;

+ (BOOL)deleteWithIndex:(NSNumber *)index;

@end
