//
//  WXHUIAdapter.m
//  UIAdapterDemo
//
//  Created by 伍小华 on 2017/6/6.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import "WXHUIAdapter.h"
#import "UIColor+WXH.h"

static NSString *const WXHUIAdapterTopicName = @"WXHUIAdapterTopicName";
NSString *const WXHUIAdapterTopicNameDefault = @"Topic_Default";

static NSString *const WXHUIAdapterTopicManager = @"WXHUIAdapterTopicManager";
static NSString *const WXHUIAdapterTopicInfoPlist = @"Topic_Info.plist";

//内容的字体以及字体大小，这里的key需要和plist的对应
NSString *const WXHUIAdapterTopicFontTitle = @"Title";
NSString *const WXHUIAdapterTopicFontContent = @"Content";
NSString *const WXHUIAdapterTopicFontDetail = @"Detail";

//颜色，这里的key需要和plist的对应
NSString *const WXHUIAdapterTopicColorTitle = @"Title";
NSString *const WXHUIAdapterTopicColorBackground = @"Background";
NSString *const WXHUIAdapterTopicColorDetail = @"Detail";
NSString *const WXHUIAdapterTopicColorAlert = @"Alert";
NSString *const WXHUIAdapterTopicColorContent = @"Content";
NSString *const WXHUIAdapterTopicColorButton = @"Button";

@interface WXHUIAdapter ()
@property (nonatomic, copy) NSString *topicName;
@property (nonatomic, strong) NSDictionary *colorDic;
@property (nonatomic, strong) NSDictionary *fontDic;
@property (nonatomic, strong) NSDictionary *sizeDic;

@property (nonatomic, strong) NSMutableDictionary *changeBlockDic;
@end
@implementation WXHUIAdapter
SINGLE_IMPLEMENTATION(WXHUIAdapter);

- (instancetype)init
{
    if (self = [super init]) {
        _topicName = [[NSUserDefaults standardUserDefaults] objectForKey:WXHUIAdapterTopicName];
        if (_topicName == nil) {
            self.topicName = WXHUIAdapterTopicNameDefault;
        }
        [self loadTopicData];
    }
    return self;
}

#pragma mark - Private
//字体、字体大小、颜色
- (void)loadTopicData
{
    NSString *infoPlistPath = [self topicPath:WXHUIAdapterTopicInfoPlist];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:infoPlistPath];
    
    self.sizeDic = dic[@"size"];
    self.fontDic = dic[@"font"];
    self.colorDic = dic[@"color"];
}

//主题对应的路径
- (NSString *)topicPath:(NSString *)name
{
    if ([self.topicName isEqualToString:WXHUIAdapterTopicNameDefault]) {
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        bundlePath = [bundlePath stringByAppendingPathComponent:name];
        return bundlePath;
    } else {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        documentPath = [documentPath stringByAppendingPathComponent:WXHUIAdapterTopicManager];
        documentPath = [documentPath stringByAppendingPathComponent:self.topicName];
        documentPath = [documentPath stringByAppendingPathComponent:name];
        return documentPath;
    }
}

#pragma mark - Public
//所有主题保存的文件夹路径
+ (NSString *)savePath
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    documentPath = [documentPath stringByAppendingPathComponent:WXHUIAdapterTopicManager];
    return documentPath;
}
//字体大小
+ (CGFloat)topicSize:(NSString *)fontName
{
    WXHUIAdapter *sharedWXHUIAdapter = [WXHUIAdapter sharedWXHUIAdapter];
    NSString *size = sharedWXHUIAdapter.sizeDic[fontName];
    return size.floatValue;
}
//字体
+ (UIFont *)topicFont:(NSString *)fontName
{
    WXHUIAdapter *sharedWXHUIAdapter = [WXHUIAdapter sharedWXHUIAdapter];
    
    NSString *name = sharedWXHUIAdapter.fontDic[fontName];
    CGFloat size = [self topicSize:fontName];
    
    if (fontName) {
        return [UIFont fontWithName:name size:size];
    } else {
        return [UIFont systemFontOfSize:size];
    }
}
//颜色
+ (UIColor *)topicColor:(NSString *)colorName
{
    WXHUIAdapter *sharedWXHUIAdapter = [WXHUIAdapter sharedWXHUIAdapter];
    NSString *color = sharedWXHUIAdapter.colorDic[colorName];
    return [UIColor colorWithHexString:color];
}
//16进制颜色
+ (NSString *)topicColorString:(NSString *)colorName
{
    WXHUIAdapter *sharedWXHUIAdapter = [WXHUIAdapter sharedWXHUIAdapter];
    NSString *color = sharedWXHUIAdapter.colorDic[colorName];
    
    if (color) {
        return color;
    } else {
        return @"#FFFFFF";
    }
}
//图片
+ (UIImage *)topicImage:(NSString *)imageName
{
    WXHUIAdapter *sharedWXHUIAdapter = [WXHUIAdapter sharedWXHUIAdapter];
    if ([sharedWXHUIAdapter.topicName isEqualToString:WXHUIAdapterTopicNameDefault]) {
        return [UIImage imageNamed:imageName];
    } else {
        NSString *imagePath = [sharedWXHUIAdapter topicPath:imageName];
        return [UIImage imageWithContentsOfFile:imagePath];
    }
}
//注册一个主题改变是调用的block
+ (void)registTopicDidChange:(TopicDidChangeBlock)topicDidChangeBlock forKey:(NSString *)key
{
    if (key) {
        WXHUIAdapter *sharedWXHUIAdapter = [WXHUIAdapter sharedWXHUIAdapter];
        if (topicDidChangeBlock) {
            WXHUIAdapterChangeBlockInfo *blockInfo = [[WXHUIAdapterChangeBlockInfo alloc] init];
            blockInfo.topicDidChangeBlock = topicDidChangeBlock;
            blockInfo.key = key;
            [sharedWXHUIAdapter.changeBlockDic setObject:blockInfo forKey:key];
            
            topicDidChangeBlock(sharedWXHUIAdapter.topicName);
        } else {
            [sharedWXHUIAdapter.changeBlockDic removeObjectForKey:key];
        }
    }
}
//删除已经注册的block
+ (void)removeTopicDidChangeForKey:(NSString *)key
{
    if (key) {
        WXHUIAdapter *sharedWXHUIAdapter = [WXHUIAdapter sharedWXHUIAdapter];
        [sharedWXHUIAdapter.changeBlockDic removeObjectForKey:key];
    }
}
//设置主题
+ (void)setTopic:(NSString *)topicName
{
    WXHUIAdapter *sharedWXHUIAdapter = [WXHUIAdapter sharedWXHUIAdapter];
    sharedWXHUIAdapter.topicName = topicName;
}

#pragma mark - Setter / Getter
- (NSMutableDictionary *)changeBlockDic
{
    if (!_changeBlockDic) {
        _changeBlockDic = [NSMutableDictionary dictionary];
    }
    return _changeBlockDic;
}

- (void)setTopicName:(NSString *)topicName
{
    if (_topicName != topicName) {
        _topicName = topicName;
        
        [[NSUserDefaults standardUserDefaults] setObject:topicName forKey:WXHUIAdapterTopicName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [sharedWXHUIAdapter loadTopicData];
        NSArray *array = [sharedWXHUIAdapter.changeBlockDic allValues];
        for (WXHUIAdapterChangeBlockInfo *blockInfo in array) {
            blockInfo.topicDidChangeBlock(sharedWXHUIAdapter.topicName);
        }
    }
}
@end
