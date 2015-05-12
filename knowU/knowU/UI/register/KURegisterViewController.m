//
//  KUSignInViewController.m
//  knowU
//
//  Created by HanJiatong on 15/5/1.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "KURegisterViewController.h"
#import "KUHTTPClient.h"
@interface KURegisterViewController ()
@end

@implementation KURegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[KUHTTPClient manager] registerWithUID:@"yy" mail:@"854692552@qq.com" password:@"123456" success:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
        NSLog(@"%@ %@", operation, model);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@ %@", operation, error);
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
