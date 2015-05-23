//
//  UIColor+Addition.h
//  knowU
//
//  Created by HanJiatong on 15/5/15.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Addition)

/** 首页灰色*/
+ (UIColor *)homepageGrayLine;

+ (UIColor *)placeholderColor;

+ (UIColor *)colorFromRGB:(int)rgbValue alpha:(CGFloat)alpha;
@end
