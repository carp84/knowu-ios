//
//  KUBrithdayTextField.m
//  knowU
//
//  Created by HanJiatong on 15/5/16.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "KUBrithdayTextField.h"
#import "CONSTS.h"
#import "Masonry.h"
@implementation KUBrithdayTextField

- (void)awakeFromNib {
   
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.touchBlock) {
        self.touchBlock();
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
