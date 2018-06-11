
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <Foundation/Foundation.h>

@interface SZVersionTool : NSObject

@property(nonatomic, copy) NSString *appId;
@property(nonatomic) BOOL isOnStore;

@property(nonatomic, copy, readonly) NSString *appStore_version;
@property(nonatomic, copy, readonly) NSString *local_version;

/// AppStore 包检测更新
@property(nonatomic, readonly) BOOL updateNeeded;

/// 审核中
@property(nonatomic, readonly) BOOL appStore_testing;

+ (instancetype)shareInstance;

@end
