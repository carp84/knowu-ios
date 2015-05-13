//
//  UILabel+Addition.m
//  knowU
//
//  Created by HanJiatong on 15/5/14.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "UILabel+Addition.h"

@implementation UILabel (Addition)

- (void)showOtherFontFromLocation:(NSInteger)location length:(NSInteger)length fontSize:(UIFont *)font{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(location, length)];
    self.attributedText = attributedString;
}

@end
