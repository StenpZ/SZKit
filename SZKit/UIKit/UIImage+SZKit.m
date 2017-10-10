
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "UIImage+SZKit.h"
#import "UIColor+SZKit.h"

#if __has_include(<SDWebImage/SDImageCache.h>)
#import <SDWebImage/SDImageCache.h>
#else
#import "SDImageCache.h"
#endif

@implementation UIImage (SZKit)

+ (UIImage *)sz_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)sz_imageWithRandomColor {
    return [self sz_imageWithColor:[UIColor sz_randomColor]];
}

+ (UIImage *)sz_imageWithImages:(NSArray<UIImage *> *)images {
    return [self sz_imageWithImages:images backGroundColor:nil];
}

+ (UIImage *)sz_imageWithImages:(NSArray<UIImage *> *)images backGroundColor:(UIColor *)color {
    return [self sz_imageWithImages:images backGroundColor:color cacheKey:nil];
}

+ (UIImage *)sz_imageWithImages:(NSArray<UIImage *> *)images backGroundColor:(UIColor *)color cacheKey:(NSString *)key {
    if (key) {
        UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
        if (cacheImage) {
            return cacheImage;
        }
    }
    
    CGSize finalSize = CGSizeMake(400, 400);
    CGRect rect = CGRectZero;
    rect.size = finalSize;
    
    UIGraphicsBeginImageContext(finalSize);
    
    if (color) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextSetLineWidth(context, 1.0);
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, 0, finalSize.height);
        CGContextAddLineToPoint(context, finalSize.width, finalSize.height);
        CGContextAddLineToPoint(context, finalSize.width, 0);
        CGContextAddLineToPoint(context, 0, 0);
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    
    if (images.count >= 2) {
        
        NSArray *rects = [self eachRectInGroupWithCount:images.count size:finalSize.width];
        int count = 0;
        for (UIImage *image in images) {
            
            if (count > rects.count-1) break;
            
            CGRect rect = CGRectFromString([rects objectAtIndex:count]);
            [image drawInRect:rect];
            count++;
        }
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[SDImageCache sharedImageCache] storeImage:newImage forKey:key completion:nil];
    return newImage;
}

+ (UIImage *)sz_imageWithImageUrls:(NSArray *)imageUrls {
    return [self sz_imageWithImageUrls:imageUrls backGroundColor:nil];
}

+ (UIImage *)sz_imageWithImageUrls:(NSArray *)imageUrls backGroundColor:(UIColor *)color {
    NSMutableArray *images = [NSMutableArray array];
    NSString *key = @"";
    for (id obj in imageUrls) {
        UIImage *image;
        if ([obj isKindOfClass:[NSString class]]) {
            key = [key stringByAppendingString:obj];
            UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:obj];
            if (!cacheImage) {
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:obj]];
                if (data) {
                    cacheImage = [UIImage imageWithData:data];
                    [[SDImageCache sharedImageCache] storeImage:cacheImage forKey:obj completion:nil];
                }
            }
            image = cacheImage;
        } else {
            key = [key stringByAppendingString:[(NSURL *)obj absoluteString]];
            UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[(NSURL *)obj absoluteString]];
            if (!cacheImage) {
                NSData *data = [NSData dataWithContentsOfURL:obj];
                if (data) {
                    cacheImage = [UIImage imageWithData:data];
                    [[SDImageCache sharedImageCache] storeImage:cacheImage forKey:[(NSURL *)obj absoluteString] completion:nil];
                }
            }
            image = cacheImage;
        }
        if (image) {
            [images addObject:image];
        }
    }
    return [self sz_imageWithImages:images backGroundColor:color cacheKey:key];
}

+ (UIImage *)sz_imageWithImageNames:(NSArray<NSString *> *)imageNames {
    return [self sz_imageWithImageNames:imageNames backGroundColor:nil];
}

+ (UIImage *)sz_imageWithImageNames:(NSArray<NSString *> *)imageNames backGroundColor:(UIColor *)color {
    NSMutableArray *images = [NSMutableArray array];
    for (NSString *name in imageNames) {
        UIImage *image = [UIImage imageNamed:name];
        if (image) {
            [images addObject:image];
        }
    }
    return [self sz_imageWithImages:images backGroundColor:color];
}

+ (NSArray *)eachRectInGroupWithCount:(NSInteger)count size:(CGFloat)sizeValue {
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];
    
    CGFloat padding = sizeValue * 0.05;
    
    CGFloat eachWidth;
    
    if (count <= 4) {
        eachWidth = (sizeValue - padding*3) / 2;
        [self getRects:array padding:padding width:eachWidth count:4];
    } else {
        padding = padding / 2;
        eachWidth = (sizeValue - padding*4) / 3;
        [self getRects:array padding:padding width:eachWidth count:9];
    }
    
    if (count < 4) {
        [array removeObjectAtIndex:0];
        CGRect rect = CGRectFromString([array objectAtIndex:0]);
        rect.origin.x = (sizeValue - eachWidth) / 2;
        [array replaceObjectAtIndex:0 withObject:NSStringFromCGRect(rect)];
        if (count == 2) {
            [array removeObjectAtIndex:0];
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:2];
            
            for (NSString *rectStr in array) {
                CGRect rect = CGRectFromString(rectStr);
                rect.origin.y -= (padding+eachWidth)/2;
                [tempArray addObject:NSStringFromCGRect(rect)];
            }
            [array removeAllObjects];
            [array addObjectsFromArray:tempArray];
        }
    } else if (count != 4 && count <= 6) {
        [array removeObjectsInRange:NSMakeRange(0, 3)];
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:6];
        
        for (NSString *rectStr in array) {
            CGRect rect = CGRectFromString(rectStr);
            rect.origin.y -= (padding+eachWidth)/2;
            [tempArray addObject:NSStringFromCGRect(rect)];
        }
        [array removeAllObjects];
        [array addObjectsFromArray:tempArray];
        
        if (count == 5) {
            [tempArray removeAllObjects];
            [array removeObjectAtIndex:0];
            
            for (int i=0; i<2; i++) {
                CGRect rect = CGRectFromString([array objectAtIndex:i]);
                rect.origin.x -= (padding+eachWidth)/2;
                [tempArray addObject:NSStringFromCGRect(rect)];
            }
            [array replaceObjectsInRange:NSMakeRange(0, 2) withObjectsFromArray:tempArray];
        }
        
    } else if (count != 4 && count < 9) {
        if (count == 8) {
            [array removeObjectAtIndex:0];
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:2];
            for (int i=0; i<2; i++) {
                CGRect rect = CGRectFromString([array objectAtIndex:i]);
                rect.origin.x -= (padding+eachWidth)/2;
                [tempArray addObject:NSStringFromCGRect(rect)];
            }
            [array replaceObjectsInRange:NSMakeRange(0, 2) withObjectsFromArray:tempArray];
        } else {
            [array removeObjectAtIndex:2];
            [array removeObjectAtIndex:0];
        }
    }
    
    return array;
}

+ (void)getRects:(NSMutableArray *)array padding:(CGFloat)padding width:(CGFloat)eachWidth count:(int)count {
    
    for (int i=0; i<count; i++) {
        int sqrtInt = (int)sqrt(count);
        int line = i%sqrtInt;
        int row = i/sqrtInt;
        CGRect rect = CGRectMake(padding * (line+1) + eachWidth * line, padding * (row+1) + eachWidth * row, eachWidth, eachWidth);
        [array addObject:NSStringFromCGRect(rect)];
    }
}

@end
