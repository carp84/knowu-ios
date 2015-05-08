//
//  KUBaseModel.h
//  knowU
//
//  Created by HanJiatong on 15/4/27.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface KUBaseModel : MTLModel <MTLJSONSerializing>

@property (assign, readonly, nonatomic) int code;
@property (assign, readonly, nonatomic) BOOL success;
@property (copy, readonly, nonatomic) NSString *message;

- (instancetype)initWithSuccess:(BOOL)success
                        message:(NSString *)message;

@end
