
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>

@class SZStarView;

@protocol SZStarViewDelegate <NSObject>

@optional
- (void)starView:(SZStarView *)starView didSelectedAtScore:(float)score;

@end

/*! 评分的星星控件 */
@interface SZStarView : UIView

@property(nonatomic, weak) id<SZStarViewDelegate> delegate;

@property(nonatomic) BOOL slideEnabled;

@property(nonatomic, readonly) CGSize starSize;

@property(nonatomic, readonly) UIEdgeInsets starInsets;

@property(nonatomic, readonly) NSUInteger starsCount;

@property(nonatomic) BOOL animated;

@property(nonatomic) float minimumScore;
@property(nonatomic) BOOL shouldIntScore;

@property(nonatomic) float score;

/*! default img_star_normal */
@property(nonatomic, copy) NSString *normalStarImageName;
/*! default img_star_selected */
@property(nonatomic, copy) NSString *selectedStarImageName;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithStarSize:(CGSize)starSize starInsets:(UIEdgeInsets)starInsets starsCount:(NSUInteger)starsCount;

@end
