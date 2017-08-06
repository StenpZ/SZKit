
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>

@interface UIColor (SZKit)


/**
 16进制颜色代码转UIColor

 @param hexString 颜色代码
 @return UIColor
 */
+ (UIColor *)sz_colorWithHexString:(NSString *)hexString;


/**
 RGB值得9位数转UIColor

 @param rgbValue RGB值得9位数
 @return UIColor
 */
+ (UIColor *)sz_colorWithRGBValue:(NSUInteger)rgbValue;


/**
 随机颜色

 @return UIColor
 */
+ (UIColor *)sz_randomColor;

@end
