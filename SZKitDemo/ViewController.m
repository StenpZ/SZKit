//
//  ViewController.m
//  SZKitDemo
//
//  Created by zxc on 2017/7/12.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import "ViewController.h"
#import "SZKit.h"
#import "SZScrollMenuItemModel.h"

@interface ViewController ()<SZScrollMenuProtocol>

@property(nonatomic, weak) UILabel *label;
@property(nonatomic, strong) SZScrollMenu *scrollMenu;
@property(nonatomic, strong) NSMutableArray<SZScrollMenuItemModel *> *menuList;
@property(nonatomic) NSInteger maxRowCount;
@property(nonatomic) NSInteger maxColumnCount;

@end

@implementation ViewController

- (void)dealloc {
    [[SZTimer shareInstance] cancelAllTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *list = @[@"http://img2.woyaogexing.com/2017/07/06/3ddbfdc42a6563a9!400x400_big.jpg",
                      @"http://img2.woyaogexing.com/2017/07/06/78d64b63b5f5523f!400x400_big.jpg",
                      @"http://img2.woyaogexing.com/2017/07/06/a6c39a9359e70b0c!400x400_big.jpg",
                      @"http://img2.woyaogexing.com/2017/07/06/aaf3e93151f97c48!400x400_big.jpg",
                      @"http://img2.woyaogexing.com/2017/07/06/ffc067fe968dfd7d!400x400_big.jpg"];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kRealLength(200), kRealLength(200))];
    [view sz_setImageWithUrls:list];
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth(), 20)];
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
    
    self.maxRowCount = 2;
    self.maxColumnCount = 5;
    
    self.menuList = [NSMutableArray array];
    for (NSInteger index = 0; index < 10; index ++) {
        SZScrollMenuItemModel *model = [[SZScrollMenuItemModel alloc] init];
        model.image = [UIImage sz_imageWithRandomColor];
        model.text = @"测试标题";
        [self.menuList addObject:model];
    }
    
    self.scrollMenu = ({
       
        SZScrollMenu *menu = [[SZScrollMenu alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), kScreenWidth(), 0)];
        [SZMenuItem appearance].iconSize = kRealLength(60);
        [SZMenuItem appearance].iconCornerRadius = kRealLength(30);
        [SZMenuItem appearance].textFont = [UIFont systemFontOfSize:kRealFontSize(11)];
        [SZMenuItem appearance].textColor = [UIColor grayColor];
        
        menu.delegate = self;
        
        menu;
    });
    [self.view addSubview:self.scrollMenu];
    [self.scrollMenu reloadData];
    
    __weak typeof(self)weakSelf = self;
    [[SZTimer shareInstance] scheduledDispatchTimerWithName:@"SZ" timeInterval:1 queue:nil repeats:YES actionOption:SZTaskOptionAbandonPrevious action:^{
        [weakSelf changeColor];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIViewController *vc = [[NSClassFromString(@"TempViewController") alloc] init];
    [self presentViewController:vc animated:true completion:nil];

//    if (self.presentedViewController) {
//        //要先dismiss结束后才能重新present否则会出现Warning: Attempt to present <UINavigationController: 0x7fdd22262800> on <UITabBarController: 0x7fdd21c33a60> whose view is not in the window hierarchy!就会present不出来登录页面
//        [self.presentedViewController dismissViewControllerAnimated:false completion:^{
//            [self presentViewController:vc animated:true completion:nil];
//        }];
//    } else {
//        [self presentViewController:vc animated:true completion:nil];
//    }

}

- (void)changeColor {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.label.backgroundColor = [UIColor sz_randomColor];
    });
}

- (NSUInteger)numberOfRowsForEachPageInScrollMenu:(SZScrollMenu *)scrollMenu {
    return self.maxRowCount;
}

- (NSUInteger)numberOfItemsForEachRowInScrollMenu:(SZScrollMenu *)scrollMenu {
    return self.maxColumnCount;
}

- (NSUInteger)numberOfMenusInScrollMenu:(SZScrollMenu *)scrollMenu {
    return self.menuList.count;
}

- (id<SZMenuItemObject>)scrollMenu:(SZScrollMenu *)scrollMenu objectAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger index = indexPath.section * self.maxColumnCount + indexPath.row;

    SZScrollMenuItemModel *model = self.menuList[index];
    
    return model;
}

- (void)scrollMenu:(SZScrollMenu *)scrollMenu didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger idx = indexPath.section * self.maxColumnCount + indexPath.row;
    
    NSString *tips = [NSString stringWithFormat:@"IndexPath: [ %ld - %ld ]\nTitle:   %@", indexPath.section,indexPath.row,self.menuList[idx].text];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tips" message:tips preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:action];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

@end
