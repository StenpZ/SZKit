
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>

@interface UIImageView (SZKit)

- (void)sz_setImageWithUrls:(NSArray *)imageUrls;

- (void)sz_setImageWithUrls:(NSArray *)imageUrls placeHolder:(UIImage *)placeholder;

/**
 通过图片地址数组设置图片

 @param imageUrls 图片地址数组
 @param placeholder 默认图片
 @param complentBlock 完成回调
 */
- (void)sz_setImageWithUrls:(NSArray *)imageUrls placeHolder:(UIImage *)placeholder complent:(void (^)(UIImage *image))complentBlock;

@end
