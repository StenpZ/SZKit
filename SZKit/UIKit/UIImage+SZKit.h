
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>

@interface UIImage (SZKit)

/// 改变着色
- (UIImage *)sz_drawWithColor:(UIColor *)color;

/**
 通过颜色生成图片

 @param color 图片的颜色
 @return UIImage
 */
+ (UIImage *)sz_imageWithColor:(UIColor *)color;

+ (UIImage *)sz_imageWithRandomColor;

+ (UIImage *)sz_imageWithImages:(NSArray <UIImage *>*)images;

/**
 通过多张图片合并成9宫格图片，可设置生成图片的背景颜色

 @param images 图片数组
 @param color 背景颜色
 @return 生成的图片
 */
+ (UIImage *)sz_imageWithImages:(NSArray<UIImage *> *)images backGroundColor:(UIColor *)color;

+ (UIImage *)sz_imageWithImageNames:(NSArray<NSString *> *)imageNames;
+ (UIImage *)sz_imageWithImageNames:(NSArray<NSString *> *)imageNames backGroundColor:(UIColor *)color;

/**
 通过图片地址数组生成9宫格图片，生成的图片默认会保存到磁盘，地址数组内容相同时会从磁盘中取

 @param imageUrls 图片地址数组
 @return 生成的图片
 */
+ (UIImage *)sz_imageWithImageUrls:(NSArray *)imageUrls;
+ (UIImage *)sz_imageWithImageUrls:(NSArray *)imageUrls backGroundColor:(UIColor *)color;

@end
