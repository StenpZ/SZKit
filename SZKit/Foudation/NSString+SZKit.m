
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "NSString+SZKit.h"

@implementation NSString (SZKit)

- (BOOL)sz_validateMobile {
    /**
     * 手机号码 166 199
     */
    NSString * MOBIL = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    
    if ([regextestmobile evaluateWithObject:self]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)sz_validateEmail {
    NSString *emailRegex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)sz_isEmoji {
    __block BOOL isEomji = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         //         NSLog(@"hs++++++++%04x",hs);
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f)
                 {
                     isEomji = YES;
                 }
                 //                 NSLog(@"uc++++++++%04x",uc);
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3|| ls ==0xfe0f) {
                 isEomji = YES;
             }
             //             NSLog(@"ls++++++++%04x",ls);
         } else {
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
         
     }];
    return isEomji;
}

- (CGFloat)heightWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    return [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
}

- (CGFloat)heightWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth lineSpace:(CGFloat)lineSpace {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpace;
    return [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName: style} context:nil].size.height;
}

- (CGFloat)widthWithFont:(UIFont *)font {
    return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.width;
}


- (NSArray<NSTextCheckingResult *> *)urlMatches {
//    NSError *error;
//    //可以识别url的正则表达式
//    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
//                                                                           options:NSRegularExpressionCaseInsensitive
//                                                                             error:&error];
//    NSArray *arrayOfAllMatches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
//    return arrayOfAllMatches;
    
    /// 如果网址和其他字符连在一起，用上面的正则识别的更准确一些但是还是有问题
    
    NSError *error;
    NSDataDetector *dataDetector=[NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    
    NSArray *arrayOfAllMatches=[dataDetector matchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    return arrayOfAllMatches;
}

- (NSArray<NSNumber *> *)locationsWithKeywords:(NSString *)keywords {
    if (!self.length || !keywords.length) {
        return nil;
    }
    NSMutableArray *arrayRanges = [NSMutableArray array];

    NSRange rang = [self rangeOfString:keywords];
    if (rang.location != NSNotFound && rang.length != 0) {
        [arrayRanges addObject:[NSNumber numberWithInteger:rang.location]];
        NSRange rang1 = {0,0};
        NSInteger location = 0;
        NSInteger length = 0;
        for (int i = 0;; i++) {
            if (0 == i) {
                location = rang.location + rang.length;
                length = self.length - rang.location - rang.length;
                rang1 = NSMakeRange(location, length);
            } else {
                location = rang1.location + rang1.length;
                length = self.length - rang1.location - rang1.length;
                rang1 = NSMakeRange(location, length);
            }
            rang1 = [self rangeOfString:keywords options:NSCaseInsensitiveSearch range:rang1];
            if (rang1.location == NSNotFound && rang1.length == 0) {
                break;
            }
            [arrayRanges addObject:[NSNumber numberWithInteger:rang1.location]];
        }
        return arrayRanges;
    }
    return nil;
}

@end
