
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <Foundation/Foundation.h>

#ifndef __OPTIMIZE__
    #define NSLog(...) NSLog(__VA_ARGS__)
#else
    #define NSLog(...) {}
#endif

/*! 控制台输出 中文、描述 */
@interface SZUnicodeLog : NSObject

@end
