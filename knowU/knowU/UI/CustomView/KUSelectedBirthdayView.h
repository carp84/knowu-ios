//
//  KUSelectedBirthdayView.h
//  knowU
//
//  Created by HanJiatong on 15/5/15.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KUSelectedBirthdayView : UIView

@property (nonatomic, copy) void (^selectedBirthdayBlock)(NSString *birthday);
@property (nonatomic, copy) void (^hiddenBirthdayBlock)();
- (void)show;
@end
