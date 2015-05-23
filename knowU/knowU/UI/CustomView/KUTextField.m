//
//  KUTextField.m
//  knowU
//
//  Created by HanJiatong on 15/5/23.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "KUTextField.h"
#import "UIColor+Addition.h"

@implementation KUTextField

- (void)setPlaceholder:(NSString *)placeholder{
    if ([placeholder length] != 0) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName : [UIColor placeholderColor]}];
        self.attributedPlaceholder = attributedString;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
