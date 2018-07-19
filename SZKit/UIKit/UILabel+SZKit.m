
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "UILabel+SZKit.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>
#import "UIView+SZKit.h"
#import "NSString+SZKit.h"
#import "SZUnicodeLog.h"

static inline CGFloat TTTFlushFactorForTextAlignment(NSTextAlignment textAlignment) {
    switch (textAlignment) {
        case NSTextAlignmentCenter:
            return 0.5f;
        case NSTextAlignmentRight:
            return 1.0f;
        case NSTextAlignmentLeft:
        default:
            return 0.0f;
    }
}

NSString * const SZLabelLinkTypeKey = @"linkType";
NSString * const SZLabelRangeKey = @"range";
NSString * const SZLabelLinkKey = @"link";

typedef NS_ENUM(NSUInteger, SZLinkType) {
    SZLinkTypeUserHandle,
    SZLinkTypeHashtag,
    SZLinkTypeURL,
};

@interface UILabel (SZKitHandle)

@property(nonatomic, strong) NSArray *handles;

- (void)handleTouches:(NSSet *)touches helighted:(BOOL)helighted complent:(void (^)(BOOL superHandle, NSString *handleText, NSInteger index))complentBlock;

@end


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

- (BOOL)autoDistinguishLinks {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setAutoDistinguishLinks:(BOOL)autoDistinguishLinks {
    objc_setAssociatedObject(self, @selector(autoDistinguishLinks), @(autoDistinguishLinks), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)linkColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLinkColor:(UIColor *)linkColor {
    objc_setAssociatedObject(self, @selector(linkColor), linkColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(NSURL *))SZLabelLinkTapBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSZLabelLinkTapBlock:(void (^)(NSURL *))SZLabelLinkTapBlock {
    objc_setAssociatedObject(self, @selector(SZLabelLinkTapBlock), SZLabelLinkTapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (NSArray<NSString *> *)handleWords {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHandleWords:(NSArray<NSString *> *)handleWords {
    objc_setAssociatedObject(self, @selector(handleWords), handleWords, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)handleWordColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHandleWordColor:(UIColor *)handleWordColor {
    objc_setAssociatedObject(self, @selector(handleWordColor), handleWordColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(NSString *, NSInteger))SZLabelHandleBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSZLabelHandleBlock:(void (^)(NSString *, NSInteger))SZLabelHandleBlock {
    objc_setAssociatedObject(self, @selector(SZLabelHandleBlock), SZLabelHandleBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray *)handles {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHandles:(NSArray *)handles {
    objc_setAssociatedObject(self, @selector(handles), handles, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)sz_text {
    return self.text;
}

- (void)setSz_text:(NSString *)sz_text {
    self.text = sz_text;
    if (!self.text) {
        return;
    }
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
    if (self.autoDistinguishLinks) {
        self.userInteractionEnabled = YES;
        NSArray *ranges = [self getRangesForURLs];
        if (ranges.count) {
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
            for (NSDictionary *url in ranges) {
                [att addAttributes:@{NSForegroundColorAttributeName: self.linkColor ? self.linkColor: [UIColor blueColor],
                                     NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
                                     } range:[url[SZLabelRangeKey] rangeValue]];
            }
            self.attributedText = att;
        }
    }
    
    if (self.handleWords) {
        self.userInteractionEnabled = YES;
        NSMutableArray *handles = [NSMutableArray array];
        for (NSString *text in self.handleWords) {
            NSArray *ranges = [self.text locationsWithKeywords:text];
            for (NSNumber *loc in ranges) {
                NSRange itemRange = NSMakeRange(loc.integerValue, text.length);
                NSDictionary *last = handles.lastObject;
                if (loc.integerValue >= [last[SZLabelRangeKey] rangeValue].location) {
                    [handles addObject:@{SZLabelLinkKey: text,
                                         SZLabelRangeKey: [NSValue valueWithRange:itemRange]}];
                    break;
                }
            }
        }
        self.handles = [handles copy];
        NSArray *ranges = self.handles;
        if (ranges.count) {
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
            for (NSDictionary *handle in ranges) {
                [att addAttributes:@{NSForegroundColorAttributeName: self.handleWordColor ? self.handleWordColor: [UIColor blueColor]} range:[handle[SZLabelRangeKey] rangeValue]];
            }
            self.attributedText = att;
        }
    }
}

- (CGFloat)sz_height {
    [self layoutIfNeeded];
    CGSize maximumLabelSize = CGSizeMake(CGRectGetWidth(self.bounds), MAXFLOAT);
    CGSize expectSize = [self sizeThatFits:maximumLabelSize];
    return expectSize.height;
}


- (NSArray *)getRangesForURLs {
    NSMutableArray *rangesForURLs = [[NSMutableArray alloc] init];;
    
    // Use a data detector to find urls in the text
    NSError *error = nil;
    NSDataDetector *detector = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:&error];
    
    NSString *plainText = self.text;
    
    NSArray *matches = [detector matchesInString:plainText
                                         options:0
                                           range:NSMakeRange(0, plainText.length)];
    
    // Add a range entry for every url we found
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match range];
        
        // If there's a link embedded in the attributes, use that instead of the raw text
        NSString *realURL = [self.attributedText attribute:NSLinkAttributeName atIndex:matchRange.location effectiveRange:nil];
        if (realURL == nil)
            realURL = [plainText substringWithRange:matchRange];
        
        if ([match resultType] == NSTextCheckingTypeLink) {
            [rangesForURLs addObject:@{SZLabelLinkTypeKey : @(SZLinkTypeURL),
                                       SZLabelRangeKey : [NSValue valueWithRange:matchRange],
                                       SZLabelLinkKey : realURL,
                                       }];
        }
    }
    
    return rangesForURLs;
}

#pragma mark - TapHandles
- (void)handleTouches:(NSSet *)touches helighted:(BOOL)helighted complent:(void (^)(BOOL, NSString *, NSInteger))complentBlock {
    CGPoint p = [[touches anyObject] locationInView:self];
    CFIndex inx = [self characterIndexAtPoint:p];
    NSRange range = NSMakeRange(0, 0);
    BOOL superHandle = YES;
    NSString *handleText = @"";
    if (self.autoDistinguishLinks) {
        NSArray *urls = [self getRangesForURLs];
        
        if (urls.count > 0) {
            for (NSDictionary *url in urls) {
                if ([self isIndex:inx inRange:[url[SZLabelRangeKey] rangeValue]]) {
                    range = [url[SZLabelRangeKey] rangeValue];
                    superHandle = NO;
                    handleText = url[SZLabelLinkKey];
                    break;
                }
            }
        }
    }
    NSInteger index = 0;
    for (NSDictionary *handle in self.handles) {
        if ([self isIndex:inx inRange:[handle[SZLabelRangeKey] rangeValue]]) {
            superHandle = NO;
            handleText = handle[SZLabelLinkKey];
            range = [handle[SZLabelRangeKey] rangeValue];
            break;
        }
        index ++;
    }
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    UIColor *color = helighted ? [UIColor lightGrayColor]: [UIColor clearColor];
    [att addAttribute:NSBackgroundColorAttributeName value:color range:range];
    self.attributedText = att;
    if (complentBlock) {
        complentBlock(superHandle, handleText, index);
    }
    complentBlock = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:touches helighted:YES complent:^(BOOL superHandle, NSString *handleText, NSInteger index) {
        if (superHandle) {
            [super touchesBegan:touches withEvent:event];
        }
    }];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:touches helighted:YES complent:^(BOOL superHandle, NSString *handleText, NSInteger index) {
        if (superHandle) {
            [super touchesMoved:touches withEvent:event];
        }
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:touches helighted:NO complent:^(BOOL superHandle, NSString *handleText, NSInteger index) {
        if (superHandle) {
            [super touchesEnded:touches withEvent:event];
        } else {
            if (self.SZLabelHandleBlock) {
                self.SZLabelHandleBlock(handleText, index);
            }
            if (self.SZLabelLinkTapBlock) {
                self.SZLabelLinkTapBlock([NSURL URLWithString:handleText]);
            }
        }
    }];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self handleTouches:touches helighted:NO complent:^(BOOL superHandle, NSString *handleText, NSInteger index) {
        if (superHandle) {
            [super touchesCancelled:touches withEvent:event];
        }
    }];
}

- (BOOL)isIndex:(CFIndex)index inRange:(NSRange)range {
    return index >= range.location && index <= range.location+range.length;
}

- (CGRect)sz_textRectForBounds:(CGRect)bounds
        limitedToNumberOfLines:(NSInteger)numberOfLines {
    bounds = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsZero);
    if (!self.attributedText) {
        return [self textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    }
    CGRect textRect = bounds;
    
    // Calculate height with a minimum of double the font pointSize, to ensure that CTFramesetterSuggestFrameSizeWithConstraints doesn't return CGSizeZero, as it would if textRect height is insufficient.
    textRect.size.height = MAX(self.font.lineHeight * MAX(2, numberOfLines), bounds.size.height);
    
    // Adjust the text to be in the center vertically, if the text size is smaller than bounds
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedText);
    
    CGSize textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, (CFIndex)[self.attributedText length]), NULL, textRect.size, NULL);
    textSize = CGSizeMake(ceil(textSize.width), ceil(textSize.height)); // Fix for iOS 4, CTFramesetterSuggestFrameSizeWithConstraints sometimes returns fractional sizes
    
    if (textSize.height < bounds.size.height) {
        CGFloat yOffset = 0.0f;
        switch (0) {
            case 0:
                yOffset = floor((bounds.size.height - textSize.height) / 2.0f);
                break;
            case 1:
                yOffset = bounds.size.height - textSize.height;
                break;
            case 2:
            default:
                break;
        }
        
        textRect.origin.y += yOffset;
    }
    CFRelease(framesetter);
    return textRect;
}

#pragma mark -****获取lable中的点击位置的字符的index
- (CFIndex)characterIndexAtPoint:(CGPoint)p {
    [self layoutIfNeeded];
    if (!CGRectContainsPoint(self.bounds, p)) {
        return NSNotFound;
    }
    
    CGRect textRect = [self sz_textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
    if (!CGRectContainsPoint(textRect, p)) {
        return NSNotFound;
    }
    
    // Offset tap coordinates by textRect origin to make them relative to the origin of frame
    p = CGPointMake(p.x - textRect.origin.x, p.y - textRect.origin.y);
    // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
    p = CGPointMake(p.x, textRect.size.height - p.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedText);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, (CFIndex)[self.attributedText length]), path, NULL);
    if (frame == NULL) {
        CGPathRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger numberOfLines = (self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines));
    if (numberOfLines == 0) {
        CFRelease(frame);
        CGPathRelease(path);
        return NSNotFound;
    }
    
    CFIndex idx = NSNotFound;
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        CGPoint lineOrigin = lineOrigins[lineIndex];
        //lineOrigin.y-=(numberOfLines-1)*[self lineSp];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        // Get bounding information of line
        CGFloat ascent = 0.0f, descent = 0.0f, leading = 0.0f;
        CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = (CGFloat)floor(lineOrigin.y - descent);
        CGFloat yMax = (CGFloat)ceil(lineOrigin.y + ascent);
        // Apply penOffset using flushFactor for horizontal alignment to set lineOrigin since this is the horizontal offset from drawFramesetter
        CGFloat flushFactor = TTTFlushFactorForTextAlignment(self.textAlignment);
        CGFloat penOffset = (CGFloat)CTLineGetPenOffsetForFlush(line, flushFactor, textRect.size.width);
        lineOrigin.x = penOffset;
        
        // Check if we've already passed the line
        if (p.y > yMax) {
            break;
        }
        // Check if the point is within this line vertically
        if (p.y >= yMin) {
            // Check if the point is within this line horizontally
            if (p.x >= lineOrigin.x && p.x <= lineOrigin.x + width) {
                // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(p.x - lineOrigin.x, p.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                break;
            }
        }
        
    }
    CFRelease(framesetter);
    CFRelease(frame);
    CGPathRelease(path);
    return idx;
}

@end
