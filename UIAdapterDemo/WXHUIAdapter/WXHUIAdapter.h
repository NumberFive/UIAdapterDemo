//
//  WXHUIAdapter.h
//  UIAdapterDemo
//
//  Created by 伍小华 on 2017/6/6.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MacroDefine.h"
#import "WXHUIAdapterChangeBlockInfo.h"

//默认主题
UIKIT_EXTERN NSString *const WXHUIAdapterTopicNameDefault;
//内容的字体以及字体大小
UIKIT_EXTERN NSString *const WXHUIAdapterTopicFontTitle;
UIKIT_EXTERN NSString *const WXHUIAdapterTopicFontContent;
UIKIT_EXTERN NSString *const WXHUIAdapterTopicFontDetail;
//颜色
UIKIT_EXTERN NSString *const WXHUIAdapterTopicColorTitle;
UIKIT_EXTERN NSString *const WXHUIAdapterTopicColorBackground;
UIKIT_EXTERN NSString *const WXHUIAdapterTopicColorDetail;
UIKIT_EXTERN NSString *const WXHUIAdapterTopicColorAlert;
UIKIT_EXTERN NSString *const WXHUIAdapterTopicColorContent;
UIKIT_EXTERN NSString *const WXHUIAdapterTopicColorButton;


@interface WXHUIAdapter : NSObject
SINGLE_INTERFACE(WXHUIAdapter);
+ (NSString *)savePath;

+ (CGFloat)topicSize:(NSString *)fontName;
+ (UIFont *)topicFont:(NSString *)fontName;
+ (UIColor *)topicColor:(NSString *)colorName;
+ (NSString *)topicColorString:(NSString *)colorName;
+ (UIImage *)topicImage:(NSString *)imageName;

+ (void)registTopicDidChange:(TopicDidChangeBlock)topicDidChangeBlock forKey:(NSString *)key;
+ (void)removeTopicDidChangeForKey:(NSString *)key;

+ (void)setTopic:(NSString *)topicName;
@end
