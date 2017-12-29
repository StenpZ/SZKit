
// 一套常用功能的Category以及常用的自定义控件集合。
// github地址：https://github.com/StenpZ/SZKit
// 用着顺手还望给个Star。Thank you！

#import "SZLeadingView.h"
#import "UIView+SZKit.h"

#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#else
#import "Masonry.h"
#endif

@interface SZLeadingViewCell : UICollectionViewCell

@property(nonatomic, strong) UIImageView *imageView;

@end

@implementation SZLeadingViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI {
    self.imageView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        imageView;
    });
}

@end


@interface SZLeadingView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SZLeadingView


+ (instancetype)shareInstance {
    static SZLeadingView *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [SZLeadingView new];
    });
    return _instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeading:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    }
    return self;
}

- (void)showLeading:(NSNotification *)noti {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    
    NSString *showedKey = [NSString stringWithFormat:@"star.leading.%@", version];
    
    NSString *flag = [def valueForKey:showedKey];
    if (flag.length) {
        return;
    }
    [self prepareUI];
    [self show];
    [def setValue:@"showed" forKey:showedKey];
    [def synchronize];
}

- (void)prepareUI {
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing =
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        [collectionView registerClass:[SZLeadingViewCell class] forCellWithReuseIdentifier:@"reuseCell"];
        
        [self addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        collectionView;
    });
}

- (void)show {
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.sz_orgin_x = - [UIScreen mainScreen].bounds.size.width;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SZLeadingViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuseCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:self.images[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [UIScreen mainScreen].bounds.size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != self.images.count - 1) {
        return;
    }
    [self hide];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.x > 2.15 * [UIScreen mainScreen].bounds.size.width) {
        [self hide];
    }
}

@end

