//
//  ViewController.m
//  UIAdapterDemo
//
//  Created by 伍小华 on 2017/6/6.
//  Copyright © 2017年 wxh. All rights reserved.
//
#import "ViewController.h"
#import "WXHUIAdapter.h"
#import "MacroDefine.h"
#import "ZipArchive.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UINavigationController *nav;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nav = [[UINavigationController alloc] initWithRootViewController:[[FirstViewController alloc] init]];
    [self addChildViewController:self.nav];
    [self.view addSubview:self.nav.view];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"默认主题" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 64, 100, 50);
    
    button.tag = 0;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"主题1" forState:UIControlStateNormal];
    button1.frame = CGRectMake(SCREEN_WIDTH-100, 64, 100, 50);
    
    button1.tag = 1;
    [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    [WXHUIAdapter registTopicDidChange:^(NSString *topicName) {
        button.backgroundColor = [WXHUIAdapter topicColor:WXHUIAdapterTopicColorButton];
        button1.backgroundColor = [WXHUIAdapter topicColor:WXHUIAdapterTopicColorButton];
        
    } forKey:@"ViewController"];
    
    //准备数据
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *savePath = [WXHUIAdapter savePath];
    
    NSString *bundlePath = PATH_BUNDLE_(@"Topic_1.zip");
    NSString *documentPath = [[WXHUIAdapter savePath] stringByAppendingPathComponent:@"Topic_1.zip"];
    
    if (![fileManager fileExistsAtPath:savePath]) {
        [fileManager createDirectoryAtPath:[WXHUIAdapter savePath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![fileManager fileExistsAtPath:documentPath]) {
        if ([fileManager copyItemAtPath:bundlePath toPath:documentPath error:nil]) {
            if ([SSZipArchive unzipFileAtPath:documentPath toDestination:savePath]) {
                NSLog(@"解压成功");
            } else {
                NSLog(@"解压失败");
            }
        }
    }
    
    NSLog(@"主题保存路径：%@",savePath);
}

- (void)buttonAction:(UIButton *)button
{
    NSInteger index = button.tag;
    if (index == 0) {
        [WXHUIAdapter setTopic:WXHUIAdapterTopicNameDefault];
    } else {
        [WXHUIAdapter setTopic:@"Topic_1"];
    }
}


@end
