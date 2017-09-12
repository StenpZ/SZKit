
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "UIColor+SZKit.h"

@implementation UIColor (SZKit)

+ (UIColor *)sz_colorWithHexString:(NSString *)hexString {
    return [self sz_colorWithHexString:hexString alpha:1.0];
}

+ (UIColor *)sz_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        return [UIColor blackColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:r/255.f
                           green:g/255.f
                            blue:b/255.f
                           alpha:alpha];
}

+ (UIColor *)sz_colorWithRGBValue:(NSUInteger)rgbValue {
    return [self sz_colorWithRGBValue:rgbValue alpha:1.0];
}

+ (UIColor *)sz_colorWithRGBValue:(NSUInteger)rgbValue alpha:(CGFloat)alpha {
    NSString *string = [NSString stringWithFormat:@"%ld", (long)rgbValue];
    if (string.length != 9) {
        return [UIColor blackColor];
    }
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [string substringWithRange:range];
    range.location = 2;
    NSString *gString = [string substringWithRange:range];
    range.location = 4;
    NSString *bString = [string substringWithRange:range];
    
    float r = rString.floatValue;
    float g = gString.floatValue;
    float b = bString.floatValue;
    
    return [UIColor colorWithRed:r/255.f
                           green:g/255.f
                            blue:b/255.f
                           alpha:alpha];
}

+ (UIColor *)sz_colorWithHex:(NSInteger)hex {
    return [self sz_colorWithHex:hex alpha:1.0];
}

+ (UIColor *)sz_colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((CGFloat)((hex & 0xFF0000) >> 16)) / 255.0
                           green:((CGFloat)((hex & 0xFF00) >> 8)) / 255.0
                            blue:((CGFloat)(hex & 0xFF)) / 255.0
                           alpha:alpha];
}

+ (UIColor *)sz_randomColor {
    int r = [self getRandomNumber:0 to:255];
    int g = [self getRandomNumber:0 to:255];
    int b = [self getRandomNumber:0 to:255];
    
    return [UIColor colorWithRed:r/255.f
                           green:g/255.f
                            blue:b/255.f
                           alpha:1.0];
}

+ (int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}

@end
