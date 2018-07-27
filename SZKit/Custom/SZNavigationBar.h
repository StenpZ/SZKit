
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>


@interface SZBarButtonItem : UIButton

- (instancetype)initWithImage:(UIImage *)image target:(id)target action:(SEL)action;
- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title target:(id)target action:(SEL)action;

@end


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
