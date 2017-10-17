//
//  ViewController.m
//  SZKitDemo
//
//  Created by zxc on 2017/7/12.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import "ViewController.h"
#import "SZKit.h"
#import <UINavigationController+FDFullscreenPopGesture.h>

@interface ViewController ()<SZScrollMenuProtocol, SZScrollBannerProtocol>

@property(nonatomic, weak) UILabel *label;
@property(nonatomic, strong) SZScrollMenu *scrollMenu;

@property(nonatomic, strong) SZScrollBanner *banner;

@end

@implementation ViewController

- (void)dealloc {
    [[SZTimer shareInstance] cancelAllTimer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.banner adjustToFitWhenWillAppear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
//    self.fd_prefersNavigationBarHidden = YES;
//    self.navigationBar.tintColor = UIColorRandom();
//    self.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationBar.leftButtonItem = [[SZBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_back"] target:self action:@selector(sz_popAction)];
////    self.navigationBar.title = @"首页";
//
//    self.navigationBar.rightButtonItems = @[[[SZBarButtonItem alloc] initWithTitle:@"更多" target:self action:@selector(nextAction)], [[SZBarButtonItem alloc] initWithTitle:@"关闭" target:self action:@selector(nextAction)]];
//    self.navigationBar.titleView = ({
//        UISearchBar *searchBar = [[UISearchBar alloc] init];
//
//        searchBar.placeholder = @"咔咔咔咔";
//
//        searchBar;
//    });
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *list = @[@"http://img2.woyaogexing.com/2017/07/06/3ddbfdc42a6563a9!400x400_big.jpg",
                      @"http://img2.woyaogexing.com/2017/07/06/78d64b63b5f5523f!400x400_big.jpg",
                      @"http://img2.woyaogexing.com/2017/07/06/a6c39a9359e70b0c!400x400_big.jpg",
                      @"http://img2.woyaogexing.com/2017/07/06/aaf3e93151f97c48!400x400_big.jpg",
                      @"http://img2.woyaogexing.com/2017/07/06/ffc067fe968dfd7d!400x400_big.jpg"];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kRealLength(100), kRealLength(100))];
    [view sz_setImageWithUrls:list];
    [self.view addSubview:view];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), kScreenWidth(), 20)];
    label.backgroundColor = [UIColor redColor];
    label.sz_lineSpace = 5;
    label.sz_characterSpace = 5;
    label.sz_keywords = @"text";
    label.sz_keywordsFont = [UIFont boldSystemFontOfSize:kRealFontSize(20)];
    label.sz_keywordsFontColor = [UIColor blueColor];
    label.sz_keywordsBackGroundColor = [UIColor yellowColor];
    label.font = [UIFont systemFontOfSize:kRealFontSize(14)];
    label.numberOfLines = 0;
    label.sz_text = @"ashfaifoadsfntextasjkfnjksdfnkatext";
    [self.view addSubview:label];
    self.label = label;
    
    self.scrollMenu = ({
       
        SZScrollMenu *menu = [[SZScrollMenu alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), kScreenWidth(), 100)];
        
        menu.delegate = self;
        
        menu;
    });
    [self.view addSubview:self.scrollMenu];
    
    __weak typeof(self)weakSelf = self;
    [[SZTimer shareInstance] scheduledDispatchTimerWithName:@"SZ" timeInterval:1 queue:nil repeats:YES actionOption:SZTaskOptionAbandonPrevious action:^{
        [weakSelf changeColor];
    }];
    
    self.banner = ({
        
        SZScrollBanner *banner = [[SZScrollBanner alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollMenu.frame), kScreenWidth(), kRealLength(100))];
        banner.delegate = self;
        
        banner;
    });
    [self.view addSubview:self.banner];
}

#pragma mark - Action
- (void)nextAction {
    UIViewController *vc = [[NSClassFromString(@"TempViewController") alloc] init];
    [self sz_pushViewController:vc animated:YES];
//    [self.scrollMenu reloadData];
}

- (void)changeColor {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.label.backgroundColor = [UIColor sz_randomColor];
    });
}

#pragma mark - SZScrollMenuProtocol
- (NSUInteger)numberOfRowsInScrollMenu:(SZScrollMenu *)scrollMenu {
    return 2;
}

- (NSUInteger)numberOfColumnsInScrollMenu:(SZScrollMenu *)scrollMenu {
    return 5;
}

- (NSUInteger)numberOfMenusInScrollMenu:(SZScrollMenu *)scrollMenu {
    return 50;
}

- (SZMenuItem *)scrollMenu:(SZScrollMenu *)scrollMenu menuItemAtIndexPath:(NSIndexPath *)indexPath {
    SZMenuItem *menuItem = [scrollMenu dequeueReusableItemForIndexPath:indexPath];
    menuItem.imageView.image = [UIImage sz_imageWithRandomColor];
    NSUInteger index = indexPath.section * [self numberOfColumnsInScrollMenu:scrollMenu] + indexPath.row;
    menuItem.textLabel.text = [NSString stringWithFormat:@"item_%02ld", (unsigned long)index];
    return menuItem;
}

- (void)scrollMenu:(SZScrollMenu *)scrollMenu didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", indexPath);
}

#pragma mark - SZScrollBannerProtocol
- (NSUInteger)numbersofPageAtScrollBanner:(SZScrollBanner *)scrollBanner {
    return 6;
}

- (SZScrollBannerCell *)scrollBanner:(SZScrollBanner *)scrollBanner cellForPageAtIndex:(NSUInteger)index {
    SZScrollBannerCell *cell = [scrollBanner dequeueReusableCellWithIdentifier:scrollBanner.defaultCellIdentifier forIndex:index];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", index];
    return cell;
}

- (void)scrollBanner:(SZScrollBanner *)scrollBanner didSelectedAtIndex:(NSUInteger)index {
    NSLog(@"点击:%ld", index);
}

@end
