
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "UILabel+SZKit.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>
#import "UIView+SZKit.h"
#import "NSString+SZKit.h"

@implementation UILabel (SZKit)

- (CGFloat)sz_characterSpace {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setSz_characterSpace:(CGFloat)sz_characterSpace {
    objc_setAssociatedObject(self, @selector(sz_characterSpace), @(sz_characterSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)sz_lineSpace {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setSz_lineSpace:(CGFloat)sz_lineSpace {
    objc_setAssociatedObject(self, @selector(sz_lineSpace), @(sz_lineSpace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)sz_keywords {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSz_keywords:(NSString *)sz_keywords {
    objc_setAssociatedObject(self, @selector(sz_keywords), sz_keywords, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIColor *)sz_keywordsFontColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSz_keywordsFontColor:(UIColor *)sz_keywordsFontColor {
    objc_setAssociatedObject(self, @selector(sz_keywordsFontColor), sz_keywordsFontColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)sz_keywordsBackGroundColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSz_keywordsBackGroundColor:(UIColor *)sz_keywordsBackGroundColor {
    objc_setAssociatedObject(self, @selector(sz_keywordsBackGroundColor), sz_keywordsBackGroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIFont *)sz_keywordsFont {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSz_keywordsFont:(UIFont *)sz_keywordsFont {
    objc_setAssociatedObject(self, @selector(sz_keywordsFont), sz_keywordsFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)sz_text {
    return self.text;
}

- (void)setSz_text:(NSString *)sz_text {
    self.text = sz_text;
    if (!self.text) {
        return;
    }
    [self layoutIfNeeded];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0,self.text.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.alignment = self.textAlignment;
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    // 行间距
    if(self.sz_lineSpace > 0){
        [paragraphStyle setLineSpacing:self.sz_lineSpace];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,self.text.length)];
    }
    
    // 字间距
    if(self.sz_characterSpace > 0){
        long number = self.sz_characterSpace;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt64Type,&number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString length])];
        
        CFRelease(num);
    }
    
    //关键字
    if (self.sz_keywords) {
        NSArray *ranges = [self.text locationsWithKeywords:self.sz_keywords];
        if (ranges.count) {
            for (NSNumber *loc in ranges) {
                NSRange itemRange = NSMakeRange(loc.integerValue, self.sz_keywords.length);
                if (self.sz_keywordsFont) {
                    [attributedString addAttribute:NSFontAttributeName value:self.sz_keywordsFont range:itemRange];
                }
                
                if (self.sz_keywordsFontColor) {
                    [attributedString addAttribute:NSForegroundColorAttributeName value:self.sz_keywordsFontColor range:itemRange];
                }
                
                if (self.sz_keywordsBackGroundColor) {
                    [attributedString addAttribute:NSBackgroundColorAttributeName value:self.sz_keywordsBackGroundColor range:itemRange];
                }
            }
        }
    }
    
    self.attributedText = attributedString;
    
    CGSize maximumLabelSize = CGSizeMake(CGRectGetWidth(self.bounds), MAXFLOAT);
    CGSize expectSize = [self sizeThatFits:maximumLabelSize];
    self.sz_height = expectSize.height;
}

@end
