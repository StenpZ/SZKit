
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "SZViewController.h"

#if __has_include(<UINavigationController+FDFullscreenPopGesture.h>)
#import <UINavigationController+FDFullscreenPopGesture.h>
#else
#import "UINavigationController+FDFullscreenPopGesture.h"
#endif

@interface SZViewController ()

@property(nonatomic, strong) SZNavigationBar *navigationBar;
@property(nonatomic, strong) SZEmptySetModel *emptySet;

@end

@implementation SZViewController

- (instancetype)initWithInfo:(id)info {
    return [self init];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SZNotificationNetStatusChanged object:nil];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationBarNeeded = YES;
        self.autoAdjustNavigationBarAlpha = NO;
        [self configProperty];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:SZNotificationNetStatusChanged object:nil];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationBarNeeded) {
        [self.view bringSubviewToFront:self.navigationBar];
    }
    [self refresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = self.interactivePopDisabled;
    [self configNavigationItems];
}

- (void)initNavigationBar {
//    self.navigationBar.tintColor = UIColorWithHexString(kColorNavigationBarTint);
//    self.navigationBar.barTintColor = UIColorWithHexString(kColorNavigationBar);
//    self.navigationBar.separatorColor = UIColorWithHex(0xDCDCDC);
}

- (void)configProperty {

}

- (void)configNavigationItems {
    
}

- (void)refresh {
    
}

- (void)loadData {
    
}

- (void)pushViewController:(SZViewController *)viewController animated:(BOOL)animated {
    viewController.navigationBar.leftButtonItem = [[SZBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navi_back"] target:viewController action:@selector(popAction)];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:animated];
}

- (void)popAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter/setter
- (SZNavigationBar *)navigationBar {
    if (!self.navigationBarNeeded) {
        return nil;
    }
    if (!_navigationBar) {
        _navigationBar = [SZNavigationBar new];
        [self.view addSubview:_navigationBar];
    }
    return _navigationBar;
}

- (void)setTitle:(NSString *)title {
    self.navigationBar.title = title;
}

- (NSString *)title {
    return self.navigationBar.title;
}

- (SZEmptySetModel *)emptySet {
    if (!_emptySet) {
        _emptySet = [SZEmptySetModel new];
    }
    return _emptySet;
}

@end
