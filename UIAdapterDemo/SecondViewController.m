//
//  SecondViewController.m
//  UIAdapterDemo
//
//  Created by 伍小华 on 2017/6/7.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import "SecondViewController.h"
#import "MacroDefine.h"
#import "WXHUIAdapter.h"

@interface SecondViewController ()
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 40)];
    self.titleLB.textAlignment = NSTextAlignmentCenter;
    self.titleLB.text = @"SecondViewController";
    [self.view addSubview:self.titleLB];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2.0, SCREEN_WIDTH, SCREEN_HEIGHT/2.0)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageView];
    
    __weak SecondViewController *weakSelf = self;
    [WXHUIAdapter registTopicDidChange:^(NSString *topicName) {
        __strong SecondViewController *strong = weakSelf;
        strong.view.backgroundColor = [WXHUIAdapter topicColor:WXHUIAdapterTopicColorBackground];
        
        strong.titleLB.backgroundColor = [WXHUIAdapter topicColor:WXHUIAdapterTopicColorDetail];
        strong.titleLB.textColor = [WXHUIAdapter topicColor:WXHUIAdapterTopicColorBackground];
        strong.titleLB.font = [WXHUIAdapter topicFont:WXHUIAdapterTopicFontTitle];
        
        strong.imageView.image = [WXHUIAdapter topicImage:@"aaaa.jpeg"];
        
        strong.title = topicName;
        
    } forKey:@"SecondViewController"];
}
- (void)dealloc
{
    //需要删除掉，不然会调用block
    [WXHUIAdapter removeTopicDidChangeForKey:@"SecondViewController"];
    NSLog(@"SecondViewController dealloc!!!");
}

@end
