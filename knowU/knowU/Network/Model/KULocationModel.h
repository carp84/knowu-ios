//
//  KULocationModel.h
//  knowU
//
//  Created by HanJiatong on 15/6/23.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KULocationModel : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, strong) NSNumber *dayOfWeek;
@property (nonatomic, copy) NSString *otherDescription;
@property (nonatomic, strong) NSNumber *isUpload;
@property (nonatomic, assign) NSInteger index;

@end
