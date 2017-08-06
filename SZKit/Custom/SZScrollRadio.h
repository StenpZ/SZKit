
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>

@class SZScrollRadio;
@class SZScrollRadioCell;

@protocol SZScrollRadioDataSource <NSObject>

- (NSUInteger)numbersOfRowAtScrollRadio:(SZScrollRadio *)scrollRadio;

- (NSUInteger)countsOfItemAtScrollRadio:(SZScrollRadio *)scrollRadio;

- (SZScrollRadioCell *)scrollRadio:(SZScrollRadio *)scrollRadio cellForRowAtIndex:(NSUInteger)index;

@end

@protocol SZScrollRadioDelegate <NSObject>

- (void)scrollRadioDidSelectedAtIndex:(NSUInteger)index;

@end

/*! 上下滚动广告视图 */
@interface SZScrollRadio : UIView

@property(nonatomic, weak) id<SZScrollRadioDataSource> dataSource;
@property(nonatomic, weak) id<SZScrollRadioDelegate> delegate;

@property(nonatomic) NSTimeInterval changeInterval;

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
- (__kindof SZScrollRadioCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (void)reloadData;

- (void)beginScroll;
- (void)stopScroll;

@end


@interface SZScrollRadioCell : UIView

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *textLabel;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
