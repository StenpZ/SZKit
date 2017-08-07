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
    
    self.maxRowCount = 2;
    self.maxColumnCount = 5;
    
    self.menuList = [NSMutableArray array];
    for (NSInteger index = 0; index < 15; index ++) {
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

#pragma mark - Action
- (void)nextAction {
    UIViewController *vc = [[NSClassFromString(@"TempViewController") alloc] init];
    [self sz_pushViewController:vc animated:YES];
}

- (void)changeColor {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.label.backgroundColor = [UIColor sz_randomColor];
    });
}

#pragma mark - SZScrollMenuProtocol
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
