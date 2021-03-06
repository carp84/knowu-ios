//
//  KUBaseModel.h
//  knowU
//
//  Created by HanJiatong on 15/4/27.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface KUBaseModel : MTLModel <MTLJSONSerializing>

@property (assign, readonly, nonatomic) NSInteger code;
@property (assign, readonly, nonatomic) int success;
@property (copy, readonly, nonatomic) NSString *message;

- (instancetype)initWithCode:(NSInteger)code
                     message:(NSString *)message
                     success:(int)success;

@end
