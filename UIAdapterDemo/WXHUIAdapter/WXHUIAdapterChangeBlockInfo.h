//
//  WXHUIAdapterChangeBlockInfo.h
//  UIAdapterDemo
//
//  Created by 伍小华 on 2017/6/6.
//  Copyright © 2017年 wxh. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^TopicDidChangeBlock)(NSString *topicName);

@interface WXHUIAdapterChangeBlockInfo : NSObject
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) TopicDidChangeBlock topicDidChangeBlock;
@end
