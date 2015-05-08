//
//  KULoginViewController.m
//  knowU
//
//  Created by HanJiatong on 15/5/1.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "KULoginViewController.h"
#import "KUHTTPClient.h"
@interface KULoginViewController ()

@end

@implementation KULoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[KUHTTPClient manager] loginWithUID:@"露露" password:@"123456" success:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
//    [[KUHTTPClient manager] fillUserInfoWithUID:@"露露"
//                                       password:@"123456"
//                                       userInfo:@{@"userId"         : @"露露",
//                                                  @"password"       : @"123456",
//                                                  @"homeAddress"    : @"露露",
//                                                  @"workAddress"    : @"露露",
//                                                  @"birthday"       : @"1996-07-09",
//                                                  @"gender"         : @2,
//                                                  @"jobDescription" : @"写代码的",
//                                                  @"mobile"         : @"12345678901"}
//                                        success:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//    [[KUHTTPClient manager] uploadTraceWithUID:@"露露" traceInfo:@{@"userId"         : @"露露",
//                                                                 @"latitude"       : @"123456",
//                                                                 @"longitude"    : @"露露",
//                                                                 @"timestamp"       : @"1996-07-09 23:58:59",
//                                                                 @"address"         : @"北京",
//                                                                 @"action" : @"写代码的",
//                                                                 @"dayOfWeek"         : @1,
//                                                                 @"otherDescription" : @"1"} success:^(AFHTTPRequestOperation *operation, KUBaseModel *model) {
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
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
