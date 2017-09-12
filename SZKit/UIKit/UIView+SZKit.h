
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>

@interface UIView (SZKit)

@property(nonatomic) CGFloat sz_width;
@property(nonatomic) CGFloat sz_height;
@property(nonatomic) CGFloat sz_orgin_x;
@property(nonatomic) CGFloat sz_orgin_y;

/*! 设置圆角 同时会设置clipsToBounds = YES */
@property(nonatomic) CGFloat sz_cornerRadius;

- (void)sz_addTapTarget:(id)target action:(SEL)action;
- (void)sz_removeTapTarget:(id)target action:(SEL)action;



@end
