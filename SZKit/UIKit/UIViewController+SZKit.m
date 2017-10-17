
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "UIViewController+SZKit.h"
#import "SZNavigationBar.h"

@implementation UIViewController (SZKit)

- (void)sz_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.navigationBar.leftButtonItem = [[SZBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_back"] target:viewController action:@selector(sz_popAction)];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:animated];
}

- (void)sz_popAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
