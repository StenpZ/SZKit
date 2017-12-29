
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "FORScrollViewEmptyAssistant.h"
#import "UIScrollView+EmptyDataSet.h"
#import <objc/runtime.h>

static char const * const kFOREmptyAssistant = "kFOREmptyAssistant";

@interface UIScrollView (EmptyConfiger)

@property (nonatomic, strong) FOREmptyAssistantConfiger *configer;

@end

@implementation UIScrollView (EmptyConfiger)

- (FOREmptyAssistantConfiger *)configer
{
    FOREmptyAssistantConfiger *configer = objc_getAssociatedObject(self, kFOREmptyAssistant);
    if ([configer isKindOfClass:[FOREmptyAssistantConfiger class]] && configer) {
        return configer;
    }
    return nil;
}

- (void)setConfiger:(FOREmptyAssistantConfiger *)configer
{
    objc_setAssociatedObject(self, kFOREmptyAssistant, configer, OBJC_ASSOCIATION_RETAIN);
}
@end


@implementation UITableView (EmptyAsistant)

- (void)emptyViewConfigerBlock:(void (^)(FOREmptyAssistantConfiger *configer))configerBlock
{
    FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
    !configerBlock ?: configerBlock(configer);
    self.configer = configer;
    self.emptyDataSetSource = self.configer;
    self.emptyDataSetDelegate = self.configer;
}

- (void)emptyViewConfiger:(FOREmptyAssistantConfiger *)configer
{
    self.configer = configer;
    self.emptyDataSetSource = self.configer;
    self.emptyDataSetDelegate = self.configer;
}

@end

@implementation UICollectionView (EmptyAsistant)

- (void)emptyViewConfigerBlock:(void (^)(FOREmptyAssistantConfiger *configer))configerBlock
{
    FOREmptyAssistantConfiger *configer = [FOREmptyAssistantConfiger new];
    !configerBlock ?: configerBlock(configer);
    self.configer = configer;
    self.emptyDataSetSource = self.configer;
    self.emptyDataSetDelegate = self.configer;
}

- (void)emptyViewConfiger:(FOREmptyAssistantConfiger *)configer
{
    self.configer = configer;
    self.emptyDataSetSource = self.configer;
    self.emptyDataSetDelegate = self.configer;
}

@end

