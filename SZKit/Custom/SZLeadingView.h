
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>

/// 引导图
/// 需要在- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 方法中设置 images

@interface SZLeadingView : UIView

/// leading 图片名数组
@property(nonatomic, strong) NSArray<NSString *> *images;

+ (instancetype)shareInstance;

@end
