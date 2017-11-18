//
//  SZNavigationBar.h
//  SZKitDemo
//
//  Created by zxc on 2017/10/16.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SZBarButtonItem : UIButton

- (instancetype)initWithImage:(UIImage *)image target:(id)target action:(SEL)action;
- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title target:(id)target action:(SEL)action;

@end


/// tips: 如果需要使用- (void)sz_pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
/// 则需要#define SZNavigationBarEnabled
@interface SZNavigationBar : UIView

@property(nonatomic, strong) SZBarButtonItem *leftButtonItem;
@property(nonatomic, strong) NSArray<SZBarButtonItem *> *leftButtonItems;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, strong) UIView *titleView;
@property(nonatomic, strong) SZBarButtonItem *rightButtonItem;
@property(nonatomic, strong) NSArray<SZBarButtonItem *> *rightButtonItems;

@property(nonatomic) BOOL separatorHidden;
@property(nonatomic, strong) UIColor *separatorColor;

@property(nonatomic, strong) UIColor *barTintColor;

@property(nonatomic) CGFloat spacing;

@end


@interface UIViewController (SZNavigationBar)

@property(nonatomic, strong, readonly) SZNavigationBar *navigationBar;

@end
