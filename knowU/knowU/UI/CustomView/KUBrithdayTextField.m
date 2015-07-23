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
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)];
    [view addGestureRecognizer:tap];
}

-(void)touch{
    if (self.touchBlock) {
        self.touchBlock();
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
