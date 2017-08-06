
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "SZUnicodeLog.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation SZUnicodeLog

@end


@implementation NSArray (SZUnicodeLog)

#if DEBUG
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    NSMutableString *desc = [NSMutableString string];
    
    NSMutableString *tabString = [[NSMutableString alloc] initWithCapacity:level];
    for (NSUInteger i = 0; i < level; ++i) {
        [tabString appendString:@"\t"];
    }
    
    NSString *tab = @"";
    if (level > 0) {
        tab = tabString;
    }
    [desc appendString:@"\t(\n"];
    
    for (id obj in self) {
        if (![obj respondsToSelector:@selector(description)]) {
            continue;
        }
        
        if ([obj isKindOfClass:[NSDictionary class]]
            || [obj isKindOfClass:[NSArray class]]
            || [obj isKindOfClass:[NSSet class]]) {
            NSString *str = [((NSDictionary *)obj) descriptionWithLocale:locale indent:level + 1];
            [desc appendFormat:@"%@\t%@,\n", tab, str];
        } else if ([obj isKindOfClass:[NSString class]]) {
            [desc appendFormat:@"%@\t\"%@\",\n", tab, obj];
        } else if ([obj isKindOfClass:[NSData class]]) {
            // 如果是NSData类型，尝试去解析结果，以打印出可阅读的数据
            NSError *error = nil;
            NSObject *result =  [NSJSONSerialization JSONObjectWithData:obj
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
            // 解析成功
            if (error == nil && result != nil) {
                if ([result isKindOfClass:[NSDictionary class]]
                    || [result isKindOfClass:[NSArray class]]
                    || [result isKindOfClass:[NSSet class]]) {
                    NSString *str = [((NSDictionary *)result) descriptionWithLocale:locale indent:level + 1];
                    [desc appendFormat:@"%@\t%@,\n", tab, str];
                } else if ([obj isKindOfClass:[NSString class]]) {
                    [desc appendFormat:@"%@\t\"%@\",\n", tab, result];
                }
            } else {
                @try {
                    NSString *str = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
                    if (str != nil) {
                        [desc appendFormat:@"%@\t\"%@\",\n", tab, str];
                    } else {
                        [desc appendFormat:@"%@\t%@,\n", tab, obj];
                    }
                }
                @catch (NSException *exception) {
                    [desc appendFormat:@"%@\t%@,\n", tab, obj];
                }
            }
        } else {
            @try {
                [desc appendFormat:@"%@\t%@,\n", tab, obj];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        }
    }
    
    [desc appendFormat:@"%@)", tab];
    
    return desc;
}
#endif

@end


@implementation NSDictionary (SZUnicodeLog)

#if DEBUG
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    NSMutableString *desc = [NSMutableString string];
    
    NSMutableString *tabString = [[NSMutableString alloc] initWithCapacity:level];
    for (NSUInteger i = 0; i < level; ++i) {
        [tabString appendString:@"\t"];
    }
    
    NSString *tab = @"";
    if (level > 0) {
        tab = tabString;
    }
    
    [desc appendString:@"\t{\n"];
    
    // 遍历数组,self就是当前的数组
    for (id key in self.allKeys) {
        id obj = [self objectForKey:key];
        
        if (![obj respondsToSelector:@selector(description)]) {
            continue;
        }
        
        if ([obj isKindOfClass:[NSString class]]) {
            [desc appendFormat:@"%@\t%@ = \"%@\",\n", tab, key, obj];
        } else if ([obj isKindOfClass:[NSArray class]]
                   || [obj isKindOfClass:[NSDictionary class]]
                   || [obj isKindOfClass:[NSSet class]]) {
            [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, [obj descriptionWithLocale:locale indent:level + 1]];
        } else if ([obj isKindOfClass:[NSData class]]) {
            // 如果是NSData类型，尝试去解析结果，以打印出可阅读的数据
            NSError *error = nil;
            NSObject *result =  [NSJSONSerialization JSONObjectWithData:obj
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
            // 解析成功
            if (error == nil && result != nil) {
                if ([result isKindOfClass:[NSDictionary class]]
                    || [result isKindOfClass:[NSArray class]]
                    || [result isKindOfClass:[NSSet class]]) {
                    NSString *str = [((NSDictionary *)result) descriptionWithLocale:locale indent:level + 1];
                    [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, str];
                } else if ([obj isKindOfClass:[NSString class]]) {
                    [desc appendFormat:@"%@\t%@ = \"%@\",\n", tab, key, result];
                }
            } else {
                @try {
                    NSString *str = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
                    if (str != nil) {
                        [desc appendFormat:@"%@\t%@ = \"%@\",\n", tab, key, str];
                    } else {
                        [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, obj];
                    }
                }
                @catch (NSException *exception) {
                    [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, obj];
                }
            }
        } else {
            @try {
                [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, obj];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        }
    }
    
    [desc appendFormat:@"%@}", tab];
    
    return desc;
}
#endif

@end

//@implementation NSObject (SZUnicodeLog)
//
//- (NSString *)description {
//    NSMutableDictionary *debugInfos = [NSMutableDictionary dictionary];
//    
//    unsigned int count = 0;
//    Ivar *ivars = class_copyIvarList(self.class, &count);
//    for (unsigned int i = 0; i < count; ++i) {
//        Ivar ivar = ivars[i];
//        
//        const char *name = ivar_getName(ivar);
//        NSString *ivarName = [NSString stringWithUTF8String:name];
//        NSLog(@"%@", ivarName);
//        
//        NSString *propertyName = ivarName;
//        if ([propertyName hasPrefix:@"_"]) {
//            propertyName = [propertyName substringFromIndex:1];
//        }
//        
//        const char *type = ivar_getTypeEncoding(ivar);
//        NSString *typeEncoding = [NSString stringWithUTF8String:type];
//        id value = nil;
//        
//        // object
//        if ([typeEncoding rangeOfString:@"@"].location != NSNotFound) {
//            value =  ((id (*)(id, SEL))objc_msgSend)((id)self, NSSelectorFromString(propertyName));
//        } else if ([typeEncoding rangeOfString:@"*"].location != NSNotFound) {
//            char *v = ((char * (*)(id, SEL))objc_msgSend)((id)self, NSSelectorFromString(propertyName));
//            value = [NSString stringWithUTF8String:v];
//        } else if ([typeEncoding rangeOfString:@"#"].location != NSNotFound) {
//            value = propertyName;
//        } else if ([typeEncoding rangeOfString:@"^"].location != NSNotFound) {
//            value = @"基本C指针";
//        } else {
//            @try {
//                value = [self valueForKey:propertyName];
//            }
//            @catch (NSException *exception) {
//                
//            }
//            @finally {
//            }
//        }
//        
//        value = value == nil ? @"<nil>" : value;
//        
//        [debugInfos setValue:value forKey:propertyName];
//    }
//    
//    free(ivars);
//    
//    return [[NSString stringWithFormat:@"SZKit为你输出对象信息：\n%@: %p", [self class], self] stringByAppendingString: debugInfos.debugDescription];
//}
//
//@end

#warning - doTo the reason of some unknow requestion create breaking, remove this category;

@implementation NSSet(SZUnicodeLog)

#if DEBUG
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    NSMutableString *desc = [NSMutableString string];
    
    NSMutableString *tabString = [[NSMutableString alloc] initWithCapacity:level];
    for (NSUInteger i = 0; i < level; ++i) {
        [tabString appendString:@"\t"];
    }
    
    NSString *tab = @"\t";
    if (level > 0) {
        tab = tabString;
    }
    [desc appendString:@"\t{(\n"];
    
    for (id obj in self) {
        if (![obj respondsToSelector:@selector(description)]) {
            continue;
        }
        
        if ([obj isKindOfClass:[NSDictionary class]]
            || [obj isKindOfClass:[NSArray class]]
            || [obj isKindOfClass:[NSSet class]]) {
            NSString *str = [((NSDictionary *)obj) descriptionWithLocale:locale indent:level + 1];
            [desc appendFormat:@"%@\t%@,\n", tab, str];
        } else if ([obj isKindOfClass:[NSString class]]) {
            [desc appendFormat:@"%@\t\"%@\",\n", tab, obj];
        } else if ([obj isKindOfClass:[NSData class]]) {
            // 如果是NSData类型，尝试去解析结果，以打印出可阅读的数据
            NSError *error = nil;
            NSObject *result =  [NSJSONSerialization JSONObjectWithData:obj
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
            // 解析成功
            if (error == nil && result != nil) {
                if ([result isKindOfClass:[NSDictionary class]]
                    || [result isKindOfClass:[NSArray class]]
                    || [result isKindOfClass:[NSSet class]]) {
                    NSString *str = [((NSDictionary *)result) descriptionWithLocale:locale indent:level + 1];
                    [desc appendFormat:@"%@\t%@,\n", tab, str];
                } else if ([obj isKindOfClass:[NSString class]]) {
                    [desc appendFormat:@"%@\t\"%@\",\n", tab, result];
                }
            } else {
                @try {
                    NSString *str = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
                    if (str != nil) {
                        [desc appendFormat:@"%@\t\"%@\",\n", tab, str];
                    } else {
                        [desc appendFormat:@"%@\t%@,\n", tab, obj];
                    }
                }
                @catch (NSException *exception) {
                    [desc appendFormat:@"%@\t%@,\n", tab, obj];
                }
            }
        } else {
            @try {
                [desc appendFormat:@"%@\t%@,\n", tab, obj];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        }
    }
    
    [desc appendFormat:@"%@)}", tab];
    
    return desc;
}
#endif

@end
