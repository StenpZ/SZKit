
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "SZAdapter.h"

CGFloat const SCREEN_WIDTH_5 = 320.f;
CGFloat const SCREEN_WIDTH_6 = 375.f;
CGFloat const SCREEN_WIDTH_6p = 414.f;
CGFloat const SCREEN_WIDTH_X = 375.f;

CGFloat const SCREEN_HEIGHT_5 = 568.f;
CGFloat const SCREEN_HEIGHT_6 = 667.f;
CGFloat const SCREEN_HEIGHT_6p = 736.f;
CGFloat const SCREEN_HEIGHT_X = 812.f;

@implementation SZAdapter

+ (instancetype)shareAdapter {
    static dispatch_once_t onceToken;
    static SZAdapter *_instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.defaultType = SZAdapterPhoneType5;
    }
    return self;
}

- (void)setDefaultType:(SZAdapterPhoneType)defaultType {
    _defaultType = defaultType;
    switch (_defaultType) {
        case SZAdapterPhoneType5:
            _defaultScreenWidth = SCREEN_WIDTH_5;
            _defaultScreenHeight = SCREEN_HEIGHT_5;
            break;
            
        case SZAdapterPhoneType6:
            _defaultScreenWidth = SCREEN_WIDTH_6;
            _defaultScreenHeight = SCREEN_HEIGHT_6;
            break;
            
        case SZAdapterPhoneType6P:
            _defaultScreenWidth = SCREEN_WIDTH_6p;
            _defaultScreenHeight = SCREEN_HEIGHT_6p;
            break;
        case SZAdapterPhoneTypeX:
            _defaultScreenWidth = SCREEN_WIDTH_X;
            _defaultScreenHeight = SCREEN_HEIGHT_X;
            break;
            
        case SZAdapterPhoneTypeOther:
            break;
        default:
            break;
    }
}

+ (SZAdapterPhoneType)currentType {
    if (ScreenHeight() == SCREEN_HEIGHT_5) return SZAdapterPhoneType5;
    
    if (ScreenHeight() == SCREEN_HEIGHT_6) return SZAdapterPhoneType6;
    
    if (ScreenHeight() == SCREEN_HEIGHT_6p) return SZAdapterPhoneType6P;
    
    if (ScreenHeight() == SCREEN_HEIGHT_X) return SZAdapterPhoneTypeX;
    
    return SZAdapterPhoneTypeOther;
}

+ (CGFloat)heightForNavigation {
    return [self heightForStatusBar] + [self heightForNavigationBar];
}

+ (CGFloat)heightForStatusBar {
    if ([self currentType] == SZAdapterPhoneTypeX) {
        return 44.f;// system is 88px
    }
    return 20.f;
}

+ (CGFloat)heightForNavigationBar {
    return 44.f;
}

+ (CGFloat)heightForBottomBar {
    if ([self currentType] == SZAdapterPhoneTypeX) {
        return 34.f;
    }
    return 0.f;
}

@end

