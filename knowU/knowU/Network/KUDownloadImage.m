//
//  KUDownloadImage.m
//  knowU
//
//  Created by HanJiatong on 15/4/28.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import "KUDownloadImage.h"
#import <UIImageView+AFNetworking.h>
#import "NSString+UTF8.h"
#import "CONSTS.h"

static KUDownloadImage *downloadImage;

@implementation KUDownloadImage

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadImage = [[KUDownloadImage alloc] init];
    });
    return downloadImage;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
       
    }
    return self;
}

#pragma mark- 从服务器下载的水印
- (void)downloadImageWithURL:(NSString *)urlString imageView:(UIImageView *)imageView{
    imageView.image = [UIImage imageNamed:@""];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[urlString UTF8Encode]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:TIME_OUT_INTERVAL];
    
    __weak UIImageView *view = imageView;
    
    [imageView setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        view.image = image;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    }];
}

#pragma mark- 带有占位图的下载
- (void)downloadImageWithURL:(NSString *)urlString imageView:(UIImageView *)imageView placeholderImageView:(UIImageView *)placeholder {
    imageView.image = [UIImage imageNamed:@""];
    placeholder.hidden = NO;
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[urlString UTF8Encode]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:TIME_OUT_INTERVAL];
    
    __weak UIImageView *view = imageView;
    
    [imageView setImageWithURLRequest:urlRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        view.image = image;
        placeholder.hidden = YES;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    }];
}

@end
