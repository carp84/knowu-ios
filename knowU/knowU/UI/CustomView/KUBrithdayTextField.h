//
//  KUBrithdayTextField.h
//  knowU
//
//  Created by HanJiatong on 15/5/16.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KUBrithdayTextField : UITextField

/** 选择事件*/
@property (nonatomic, copy) void (^touchBlock)();

@end
