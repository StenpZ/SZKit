
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "SZTimer.h"

@interface SZTimer ()

@property (nonatomic, strong) NSMutableDictionary *timerContainer;
@property (nonatomic, strong) NSMutableDictionary *actionBlockCache;

@end

@implementation SZTimer

+ (instancetype)shareInstance {
    static SZTimer *_instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.logEnabled = YES;
        NSLog(@"SZTimer初始化成功！");
    }
    return self;
}

- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                          timeInterval:(double)interval
                                 queue:(dispatch_queue_t)queue
                               repeats:(BOOL)repeats
                          actionOption:(SZTaskOption)option
                                action:(dispatch_block_t)action {
    
    if (!timerName) return;
    
    if (!queue) {
        
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    
    if (!timer) {
        
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_resume(timer);
        [self.timerContainer setObject:timer forKey:timerName];
    }
    
    /* timer精度为0.1秒 */
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    
    __weak typeof(self)weakSelf = self;
    
    switch (option) {
            
        case SZTaskOptionAbandonPrevious:
        {
            /* 移除之前的action */
            [self removeActionCacheForTimer:timerName];
            
            dispatch_source_set_event_handler(timer, ^{
                
                __strong typeof(self)strongSelf = weakSelf;
                
                if (strongSelf.logEnabled) {
                    NSLog(@"SZTimer：%@ 执行任务：%@", timerName, action);
                }
                action();
                if (!repeats) {
                    [strongSelf cancelTimerWithName:timerName];
                }
            });
        }
            break;
            
        case SZTaskOptionMergePrevious:
        {
            /* cache本次的action */
            [self cacheAction:action forTimer:timerName];
            
            dispatch_source_set_event_handler(timer, ^{
                
                __strong typeof(self)strongSelf = weakSelf;
                
                NSMutableArray *actionArray = [self.actionBlockCache objectForKey:timerName];
                
                [actionArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    dispatch_block_t actionBlock = obj;
                    if (strongSelf.logEnabled) {
                        NSLog(@"SZTimer：%@ 执行任务：%@", timerName, actionBlock);
                    }
                    actionBlock();
                }];
                
                [strongSelf removeActionCacheForTimer:timerName];
                if (!repeats) {
                    
                    [strongSelf cancelTimerWithName:timerName];
                }
            });
        }
            break;
    }
}

- (void)cancelTimerWithName:(NSString *)timerName {
    
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    
    if (!timer) return;
    [self.timerContainer removeObjectForKey:timerName];
    dispatch_source_cancel(timer);
    [self.actionBlockCache removeObjectForKey:timerName];
    if (self.logEnabled) {
        NSLog(@"SZTimer：%@ 被取消", timerName);
        NSLog(@"SZTimer执行中的Timer列表：%@", self.timerContainer);
    }
}

- (void)cancelAllTimer {
    // Fast Enumeration
    [self.timerContainer enumerateKeysAndObjectsUsingBlock:^(NSString *timerName, dispatch_source_t timer, BOOL *stop) {
        
        [self.timerContainer removeObjectForKey:timerName];
        dispatch_source_cancel(timer);
    }];
}

- (BOOL)existTimer:(NSString *)timerName {
    
    if ([self.timerContainer objectForKey:timerName]) return YES;
    
    return NO;
}

#pragma mark - Property
- (NSMutableDictionary *)timerContainer {
    
    if (!_timerContainer) {
        _timerContainer = [[NSMutableDictionary alloc] init];
    }
    return _timerContainer;
}

- (NSMutableDictionary *)actionBlockCache {
    
    if (!_actionBlockCache) {
        _actionBlockCache = [[NSMutableDictionary alloc] init];
    }
    return _actionBlockCache;
}

#pragma mark - Action Cache
- (void)cacheAction:(dispatch_block_t)action forTimer:(NSString *)timerName {
    
    id actionArray = [self.actionBlockCache objectForKey:timerName];
    
    if (actionArray && [actionArray isKindOfClass:[NSMutableArray class]]) {
       
        [(NSMutableArray *)actionArray addObject:action];
        if (self.logEnabled) {
            NSLog(@"SZTimer：%@ 添加任务：%@", timerName, action);
        }
    } else {
        
        NSMutableArray *array = [NSMutableArray arrayWithObject:action];
        [self.actionBlockCache setObject:array forKey:timerName];
        if (self.logEnabled) {
            NSLog(@"SZTimer：%@ 添加任务：%@", timerName, action);
        }
    }
}

- (void)removeActionCacheForTimer:(NSString *)timerName {
    
    if (![self.actionBlockCache objectForKey:timerName]) return;
    
    [self.actionBlockCache removeObjectForKey:timerName];
    if (self.logEnabled) {
        NSLog(@"SZTimer：%@ 删除任务", timerName);
    }
}


@end
