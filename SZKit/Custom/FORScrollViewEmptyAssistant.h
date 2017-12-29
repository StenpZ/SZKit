
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>
#import "FOREmptyAssistantConfiger.h"

@interface UITableView (EmptyAsistant)

- (void)emptyViewConfigerBlock:(void (^)(FOREmptyAssistantConfiger *configer))configerBlock;

- (void)emptyViewConfiger:(FOREmptyAssistantConfiger *)configer;

@end

@interface UICollectionView (EmptyAsistant)

- (void)emptyViewConfigerBlock:(void (^)(FOREmptyAssistantConfiger *configer))configerBlock;

- (void)emptyViewConfiger:(FOREmptyAssistantConfiger *)configer;

@end

