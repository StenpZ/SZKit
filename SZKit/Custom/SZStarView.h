
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

@property(nonatomic, readonly) NSUInteger starsCount;

@property(nonatomic) BOOL animated;

@property(nonatomic) float score;

- (instancetype)initWithFrame:(CGRect)frame normalStar:(NSString *)normalStar selectedStar:(NSString *)selectedStar starsCount:(NSUInteger)starsCount;

@end
