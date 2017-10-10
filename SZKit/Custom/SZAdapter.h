
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SZAdapterPhoneType) {
    SZAdapterPhoneType5,
    SZAdapterPhoneType6,
    SZAdapterPhoneType6P,
    SZAdapterPhoneTypeOther
};

UIKIT_EXTERN CGFloat const SCREEN_WIDTH_5;
UIKIT_EXTERN CGFloat const SCREEN_WIDTH_6;
UIKIT_EXTERN CGFloat const SCREEN_WIDTH_6p;

UIKIT_EXTERN CGFloat const SCREEN_HEIGHT_5;
UIKIT_EXTERN CGFloat const SCREEN_HEIGHT_6;
UIKIT_EXTERN CGFloat const SCREEN_HEIGHT_6p;

/*! 屏幕宽度 */
static inline CGFloat kScreenWidth() {
    return [UIScreen mainScreen].bounds.size.width;
}

/*! 屏幕高度 */
static inline CGFloat kScreenHeight() {
    return [UIScreen mainScreen].bounds.size.height;
}

/*! 当前屏幕类型 */
static inline SZAdapterPhoneType kCurrentType() {
    if (kScreenHeight() == SCREEN_HEIGHT_5) return SZAdapterPhoneType5;
    
    if (kScreenHeight() == SCREEN_HEIGHT_6) return SZAdapterPhoneType6;
    
    if (kScreenHeight() == SCREEN_HEIGHT_6p) return SZAdapterPhoneType6P;
    
    return SZAdapterPhoneTypeOther;
}


/*! 屏幕及字体的等比适配 */
@interface SZAdapter : NSObject

/*! 屏幕适配参考类型 默认为SZAdapterPhoneType5  */
@property(nonatomic) SZAdapterPhoneType defaultType;

@property(nonatomic, readonly) CGFloat defaultScreenWidth;
@property(nonatomic, readonly) CGFloat defaultScreenHeight;

+ (instancetype)shareAdapter;

@end

//注：屏幕及字体是以屏幕宽度来适配的


/**
 计算真实字体大小

 @param defaultSize 设计字体大小
 @return 真实字体大小
 */
static inline CGFloat kRealFontSize(CGFloat defaultSize) {
    if ([SZAdapter shareAdapter].defaultType == kCurrentType()) return defaultSize;
    
    return kScreenWidth() / [SZAdapter shareAdapter].defaultScreenWidth * defaultSize;
}


/**
 计算真实长度

 @param defaultLength 设计长度
 @return 真实长度
 */
static inline CGFloat kRealLength(CGFloat defaultLength) {
    if ([SZAdapter shareAdapter].defaultType == kCurrentType()) return defaultLength;
    
    return kScreenWidth() / [SZAdapter shareAdapter].defaultScreenWidth * defaultLength;
}
