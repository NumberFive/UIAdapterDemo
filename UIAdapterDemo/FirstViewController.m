//
//  FirstViewController.m
//  UIAdapterDemo
//
//  Created by 伍小华 on 2017/6/7.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import "FirstViewController.h"
#import "MacroDefine.h"
#import "WXHUIAdapter.h"
#import "SecondViewController.h"

@interface FirstViewController ()
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 40)];
    self.titleLB.textAlignment = NSTextAlignmentCenter;
    self.titleLB.text = @"FirstViewController";
    [self.view addSubview:self.titleLB];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2.0, SCREEN_WIDTH, SCREEN_HEIGHT/2.0)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageView];
    
    __weak FirstViewController *weakSelf = self;
    [WXHUIAdapter registTopicDidChange:^(NSString *topicName) {
        __strong FirstViewController *strong = weakSelf;
        strong.view.backgroundColor = [WXHUIAdapter topicColor:WXHUIAdapterTopicColorBackground];
        
        strong.titleLB.backgroundColor = [WXHUIAdapter topicColor:WXHUIAdapterTopicColorDetail];
        strong.titleLB.textColor = [WXHUIAdapter topicColor:WXHUIAdapterTopicColorBackground];
        strong.titleLB.font = [WXHUIAdapter topicFont:WXHUIAdapterTopicFontTitle];
        
        strong.imageView.image = [WXHUIAdapter topicImage:@"aaaa.jpeg"];
        strong.title = topicName;
        
    } forKey:@"FirstViewController"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"下一个页面" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 100, 100);
    button.backgroundColor = [UIColor brownColor];
    button.center = self.view.center;
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)buttonAction
{
    [self.navigationController pushViewController:[[SecondViewController alloc] init] animated:YES];
}

- (void)dealloc
{
    //需要删除掉，不然会调用block
    [WXHUIAdapter removeTopicDidChangeForKey:@"FirstViewController"];
    NSLog(@"FirstViewController dealloc!!!");
}

@end
