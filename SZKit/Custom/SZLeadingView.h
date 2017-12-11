//
//  SZLeadingView.h
//  SZKitDemo
//
//  Created by zxc on 2017/12/11.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 引导图
/// 需要在- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 方法中设置 images

@interface SZLeadingView : UIView

/// leading 图片名数组
@property(nonatomic, strong) NSArray<NSString *> *images;

+ (instancetype)shareInstance;

@end
