//
//  KUDownloadImage.h
//  knowU
//
//  Created by HanJiatong on 15/4/28.
//  Copyright (c) 2015年 HanJiatong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KUDownloadImage : NSObject

/**
 *  从服务器下载的水印
 *
 *  @param URLString  URL
 *  @param imageView  需要下载图片的imageView
 */

- (void)downloadImageWithURL:(NSString *)urlString imageView:(UIImageView *)imageView;

/**
 *  带有占位图的下载
 *
 *  @param URLString            URL
 *  @param imageView            需要下载图片的imageView
 *  @param placeholderImageView 占位图
 */

- (void)downloadImageWithURL:(NSString *)urlString imageView:(UIImageView *)imageView placeholderImageView:(UIImageView *)placeholder;

@end
