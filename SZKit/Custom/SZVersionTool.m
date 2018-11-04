
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "SZVersionTool.h"
#import "SZUnicodeLog.h"

@interface SZVersionTool ()

@property(nonatomic, copy, readwrite) NSString *appStore_version;
@property(nonatomic, copy, readwrite) NSString *local_version;

@property(nonatomic, copy) NSString *releaseNotes;
@property(nonatomic, readonly) NSInteger version_appStore;
@property(nonatomic, readonly) NSInteger version_local;

@end

@implementation SZVersionTool


+ (instancetype)shareInstance {
    static SZVersionTool *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadVersion];
    }
    return self;
}

- (void)setAppId:(NSString *)appId {
    _appId = appId;
    if (!_appId) {
        return;
    }
    [self loadVersion];
}

- (void)setAppStore_version:(NSString *)appStore_version {
    _appStore_version = appStore_version;
    NSArray *list = [_appStore_version componentsSeparatedByString:@"."];
    _version_appStore = [list componentsJoinedByString:@""].integerValue;
}

- (void)setLocal_version:(NSString *)local_version {
    _local_version = local_version;
    NSArray *list = [_local_version componentsSeparatedByString:@"."];
    _version_local = [list componentsJoinedByString:@""].integerValue;
}

- (void)saveToDisk {
    [[NSUserDefaults standardUserDefaults] setValue:self.appStore_version forKey:@"star.version.appstore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadVersion {
    // 快捷方式获得session对象
    self.local_version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    self.appStore_version = [[NSUserDefaults standardUserDefaults] stringForKey:@"star.version.appstore"];
    if (!self.appStore_version) {
        self.appStore_version = @"0";
        [self saveToDisk];
    }
    if (!self.appId.length) {
        return;
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@", self.appId]];
    // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
    @weakify(self);
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        @strongify(self);
        if (error) {
            return;
        }
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([responseObject[@"resultCount"] integerValue]) {
            NSDictionary *result = [responseObject objectForKey:@"results"][0];
            self.appStore_version = result[@"version"];
            self.releaseNotes = result[@"releaseNotes"];
            [self saveToDisk];
        }
    }];
    
    // 启动任务
    [task resume];
}

- (BOOL)updateNeeded {
    if (_isOnStore) {
        return self.version_appStore > self.version_local;
    }
    return NO;
}

- (BOOL)appStore_testing {
    if (_isOnStore) {
        if (self.version_appStore != self.version_local) {
            [self loadVersion];
        }
        return self.version_appStore < self.version_local;
    }
    return NO;
}

@end
