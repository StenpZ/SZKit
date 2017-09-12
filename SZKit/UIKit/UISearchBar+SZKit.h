
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>

@interface UISearchBar (SZKit)

- (void)sz_setTextFont:(UIFont *)font;
- (void)sz_setTextColor:(UIColor *)textColor;
- (void)sz_setCancelButtonTitle:(NSString *)title;
/**
 *  设置取消按钮字体
 *
 *  @param font 字体
 */
- (void)sz_setCancelButtonFont:(UIFont *)font;

- (void)sz_placeholderLayoutLeft;

@end
