
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>
#import "SZItemModel.h"
#if __has_include(<SZKit/SZNavigationBar.h>)
#import <SZKit/SZNavigationBar.h>
#else
#import "SZNavigationBar.h"
#endif

#import "SZEmptySetModel.h"

/// 网络状态
static BOOL net_status;

/// 使用这个默认使用SZNavigationBar替换系统导航栏
@interface SZViewController : UIViewController

/// 全屏滑动返回开关
@property(nonatomic) BOOL interactivePopDisabled;
/// 导航栏相关
@property(nonatomic) BOOL navigationBarNeeded;
@property(nonatomic, strong, readonly) SZNavigationBar *navigationBar;

@property(nonatomic, strong, readonly) SZEmptySetModel *emptySet;

@property(nonatomic) BOOL autoAdjustNavigationBarAlpha;

/// 传递参数
- (instancetype)initWithInfo:(id)info;

/// 设置基础属性 非对象类型的属性 Look：override only
- (void)configProperty;

/// 设置导航栏属性
- (void)configNavigationItems;

/// 刷新 在viewWillAppear中被调用
- (void)refresh;

/// 加载数据
- (void)loadData;

/**
 便利push 需要提供一张名为img_back的返回按钮图片
 非 backBarButtonItem，而是viewController的leftBarButtonItem
 
 @param viewController 下一个控制器
 @param animated 是否需要动画
 */
- (void)pushViewController:(SZViewController *)viewController animated:(BOOL)animated;

/**
 返回按钮事件，默认返回上一页
 */
- (void)popAction;

@end
