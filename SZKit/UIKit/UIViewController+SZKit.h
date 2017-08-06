
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>

@interface UIViewController (SZKit)


/**
 便利push 需要提供一张名为img_back的返回按钮图片
 非 backBarButtonItem，而是viewController的leftBarButtonItem

 @param viewController 下一个控制器
 @param animated 是否需要动画
 */
- (void)sz_pushViewController:(UIViewController *)viewController animated:(BOOL)animated;


/**
 返回按钮事件，默认返回上一页
 */
- (void)sz_popAction;

@end
