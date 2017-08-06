
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import <Foundation/Foundation.h>

// 参考自JX_GCDTimer git：https://github.com/Joeyqiushi/JX_GCDTimer

typedef NS_ENUM(NSUInteger, SZTaskOption) {
    SZTaskOptionAbandonPrevious, //!<  废除前面的任务
    SZTaskOptionMergePrevious //!< 合并前面的任务
};

/*! GCD实现的Timer
 *  注意使用时block需要weak
 *  定时结束需要cancel，在某些地方使用时可能需要在dealloc方法中cancel
 */
@interface SZTimer : NSObject

@property(nonatomic) BOOL logEnabled;

+ (instancetype)shareInstance;

/**
 启动一个timer，默认精度为0.1秒。
 
 @param timerName       timer的名称，作为唯一标识。
 @param interval        执行的时间间隔。
 @param queue           timer将被放入的队列，也就是最终action执行的队列。传入nil将自动放到一个子线程队列中。
 @param repeats         timer是否循环调用。
 @param option          多次schedule同一个timer时的操作选项(目前提供将之前的任务废除或合并的选项)。
 @param action          时间间隔到点时执行的block。
 */
- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                          timeInterval:(double)interval
                                 queue:(dispatch_queue_t)queue
                               repeats:(BOOL)repeats
                          actionOption:(SZTaskOption)option
                                action:(dispatch_block_t)action;

/**
 撤销某个timer。
 
 @param timerName timer的名称，作为唯一标识。
 */
- (void)cancelTimerWithName:(NSString *)timerName;

/**
 撤销所有的timer
 */
- (void)cancelAllTimer;

/**
 *  是否存在某个名称标识的timer。
 *
 *  @param timerName timer的唯一名称标识。
 *
 *  @return YES表示存在，反之。
 */
- (BOOL)existTimer:(NSString *)timerName;

@end
