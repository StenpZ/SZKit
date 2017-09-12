
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
 16进制颜色代码转UIColor

 @param hexString 颜色代码
 @param alpha 透明度
 @return UIColor
 */
+ (UIColor *)sz_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/**
 RGB值得9位数转UIColor

 @param rgbValue RGB值得9位数
 @return UIColor
 */
+ (UIColor *)sz_colorWithRGBValue:(NSUInteger)rgbValue;

/**
 RGB值得9位数转UIColor

 @param rgbValue RGB值得9位数
 @param alpha 透明度
 @return UIColor
 */
+ (UIColor *)sz_colorWithRGBValue:(NSUInteger)rgbValue alpha:(CGFloat)alpha;

/**
 16进制颜色转UIColor

 @param hex 16进制颜色
 @return UIColor
 */
+ (UIColor *)sz_colorWithHex:(NSInteger)hex;

/**
 16进制颜色转UIColor

 @param hex 16进制颜色
 @param alpha 透明度
 @return UIColor
 */
+ (UIColor *)sz_colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;

/**
 随机颜色

 @return UIColor
 */
+ (UIColor *)sz_randomColor;

@end

/*! 16进制颜色 */
static inline UIColor * UIColorWithHex(NSInteger hex) {
    return [UIColor sz_colorWithHex:hex];
}

/*! RGB颜色 */
static inline UIColor * UIColorWithRGB(NSInteger rgb) {
    return [UIColor sz_colorWithRGBValue:rgb];
}

/*! 随机颜色 */
static inline UIColor * UIColorRandom() {
    return [UIColor sz_randomColor];
}
