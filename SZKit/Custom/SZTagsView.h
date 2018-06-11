
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>

@class SZTagsView;

@protocol SZTagsViewProtocol <NSObject>

- (NSInteger)numberOfItemsInTagsView:(SZTagsView *)tagsView;

- (NSString *)tagsView:(SZTagsView *)tagsView titleForItemAtIndex:(NSInteger)index;

@optional
- (void)tagsView:(SZTagsView *)tagsView didSelectItemAtIndex:(NSInteger)index;

- (void)tagsView:(SZTagsView *)tagsView heightUpdated:(CGFloat)height;

@end


@interface SZTagsView : UIView


@property(nonatomic) CGFloat itemFontSize;
@property(nonatomic, strong) UIColor *itemTextColor;
@property(nonatomic, strong) UIColor *itemBackgroundColor;

@property(nonatomic) NSInteger tagCornerRadius;

@property(nonatomic) CGFloat cellHeight;

@property(nonatomic, weak) id<SZTagsViewProtocol> delegate;

- (void)reloadData;

@end
