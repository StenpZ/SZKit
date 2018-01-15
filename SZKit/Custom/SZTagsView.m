//
//  SZTagsView.m
//  SZKitDemo
//
//  Created by StenpZ on 2018/1/15.
//  Copyright © 2018年 StenpZ. All rights reserved.
//

#import "SZTagsView.h"
#import "NSString+SZKit.h"
#import "UIView+SZKit.h"

#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#else
#import "Masonry.h"
#endif

static CGFloat kDefaultCellHeight = 24;

@interface SZTagsViewCell : UICollectionViewCell

@property(nonatomic,copy) NSString *content;
@property(nonatomic, strong) UILabel *tagLabel;

@end

@implementation SZTagsViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tagLabel = ({
            UILabel *label = [UILabel new];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor lightGrayColor];
            [self.contentView addSubview:label];
            
            label;
        });
        [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setContent:(NSString *)content {
    _content = content;
    [_tagLabel setText:content];
}

+ (CGSize)getSizeWithContent:(NSString *) content maxWidth:(CGFloat)maxWidth customHeight:(CGFloat)cellHeight {
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize size = [content boundingRectWithSize:CGSizeMake(maxWidth-20, 24) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:style} context:nil].size;
    return CGSizeMake(size.width+20, cellHeight);
}

@end


@interface UICollectionViewLeftAlignedLayout : UICollectionViewFlowLayout

@end

/**
 *  Just a convenience protocol to keep things consistent.
 *  Someone could find it confusing for a delegate object to conform to UICollectionViewDelegateFlowLayout
 *  while using UICollectionViewLeftAlignedLayout.
 */
@protocol UICollectionViewDelegateLeftAlignedLayout <UICollectionViewDelegateFlowLayout>

@end

@interface UICollectionViewLayoutAttributes (LeftAligned)

- (void)leftAlignFrameWithSectionInset:(UIEdgeInsets)sectionInset;

@end

@implementation UICollectionViewLayoutAttributes (LeftAligned)

- (void)leftAlignFrameWithSectionInset:(UIEdgeInsets)sectionInset
{
    CGRect frame = self.frame;
    frame.origin.x = sectionInset.left;
    self.frame = frame;
}

@end

#pragma mark -

@implementation UICollectionViewLeftAlignedLayout

#pragma mark - UICollectionViewLayout
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *originalAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *updatedAttributes = [NSMutableArray arrayWithArray:originalAttributes];
    for (UICollectionViewLayoutAttributes *attributes in originalAttributes) {
        if (!attributes.representedElementKind) {
            NSUInteger index = [updatedAttributes indexOfObject:attributes];
            updatedAttributes[index] = [self layoutAttributesForItemAtIndexPath:attributes.indexPath];
        }
    }
    
    return updatedAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* currentItemAttributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
    UIEdgeInsets sectionInset = [self evaluatedSectionInsetForItemAtIndex:indexPath.section];
    
    BOOL isFirstItemInSection = indexPath.item == 0;
    CGFloat layoutWidth = CGRectGetWidth(self.collectionView.frame) - sectionInset.left - sectionInset.right;
    
    if (isFirstItemInSection) {
        [currentItemAttributes leftAlignFrameWithSectionInset:sectionInset];
        return currentItemAttributes;
    }
    
    NSIndexPath* previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
    CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
    CGFloat previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width;
    CGRect currentFrame = currentItemAttributes.frame;
    CGRect strecthedCurrentFrame = CGRectMake(sectionInset.left,
                                              currentFrame.origin.y,
                                              layoutWidth,
                                              currentFrame.size.height);
    // if the current frame, once left aligned to the left and stretched to the full collection view
    // widht intersects the previous frame then they are on the same line
    BOOL isFirstItemInRow = !CGRectIntersectsRect(previousFrame, strecthedCurrentFrame);
    
    if (isFirstItemInRow) {
        // make sure the first item on a line is left aligned
        [currentItemAttributes leftAlignFrameWithSectionInset:sectionInset];
        return currentItemAttributes;
    }
    
    CGRect frame = currentItemAttributes.frame;
    frame.origin.x = previousFrameRightPoint + [self evaluatedMinimumInteritemSpacingForSectionAtIndex:indexPath.section];
    currentItemAttributes.frame = frame;
    return currentItemAttributes;
}

- (CGFloat)evaluatedMinimumInteritemSpacingForSectionAtIndex:(NSInteger)sectionIndex
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        id<UICollectionViewDelegateLeftAlignedLayout> delegate = (id<UICollectionViewDelegateLeftAlignedLayout>)self.collectionView.delegate;
        
        return [delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:sectionIndex];
    } else {
        return self.minimumInteritemSpacing;
    }
}

- (UIEdgeInsets)evaluatedSectionInsetForItemAtIndex:(NSInteger)index
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        id<UICollectionViewDelegateLeftAlignedLayout> delegate = (id<UICollectionViewDelegateLeftAlignedLayout>)self.collectionView.delegate;
        
        return [delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:index];
    } else {
        return self.sectionInset;
    }
}

@end


@interface SZTagsView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SZTagsView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemFontSize = 12;
        [self addSubview:self.collectionView];
        self.cellHeight = kDefaultCellHeight;
    }
    return self;
}

#pragma mark - Layout
/** 适应布局变换 */
- (void) layoutSubviews
{
    [super layoutSubviews];
    
    UICollectionViewLeftAlignedLayout *layout = (UICollectionViewLeftAlignedLayout *)_collectionView.collectionViewLayout;
    [layout invalidateLayout];
    
    _collectionView.frame = self.bounds;
    if (!CGSizeEqualToSize(self.bounds.size, [self intrinsicContentSize])) {
        [self invalidateIntrinsicContentSize];
    }
    CGFloat height = _collectionView.collectionViewLayout.collectionViewContentSize.height;
    if (height != 0 && height != self.bounds.size.height) {
        CGRect frame = self.frame;
        frame.size.height = height;
        self.frame = frame;
        _collectionView.frame = self.bounds;
        if ([self.delegate respondsToSelector:@selector(tagsView:heightUpdated:)]) {
            [self.delegate tagsView:self heightUpdated:height];
        }
    }
    
}

- (CGSize)intrinsicContentSize
{
    NSLog(@"height---%f",_collectionView.collectionViewLayout.collectionViewContentSize.height);
    return _collectionView.collectionViewLayout.collectionViewContentSize;
}

#pragma mark - Actions

- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.delegate numberOfItemsInTagsView:self];
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SZTagsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.tagLabel.font = [self itemFont];
    cell.content = [self.delegate tagsView:self titleForItemAtIndex:indexPath.row];
    if (self.itemTextColor) {
        cell.tagLabel.textColor = self.itemTextColor;
    }
    if (self.itemBackgroundColor) {
        cell.tagLabel.backgroundColor = self.itemBackgroundColor;
    }
    if (self.tagCornerRadius) {
        cell.sz_cornerRadius = self.tagCornerRadius;
    }
    return cell;
}

#pragma mark - UI_Style

/** 绘画圆角 解决卡顿*/
-(UIView *)drawConnerView:(CGFloat)cornerRadius rect:(CGRect)frame backgroudColor:(UIColor *)backgroud_color borderColor:(UIColor *)borderColor{
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGRect bounds = CGRectInset(frame, 0, 0);
    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), cornerRadius);
    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMinY(bounds), cornerRadius);
    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMinX(bounds), CGRectGetMinY(bounds), cornerRadius);
    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMinX(bounds), CGRectGetMaxY(bounds), cornerRadius);
    layer.path = pathRef;
    CFRelease(pathRef);
    layer.strokeColor = [borderColor CGColor];
    layer.fillColor = backgroud_color.CGColor;
    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
    [roundView.layer insertSublayer:layer atIndex:0];
    roundView.backgroundColor = UIColor.clearColor;
    return roundView;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tagsView:didSelectItemAtIndex:)]) {
        [self.delegate tagsView:self didSelectItemAtIndex:indexPath.row];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self getSizeWithContent:[self.delegate tagsView:self titleForItemAtIndex:indexPath.row] maxWidth:_collectionView.frame.size.width customHeight:self.cellHeight];
}

#pragma mark - Lazy loading

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) collectionViewLayout:[[UICollectionViewLeftAlignedLayout alloc] init]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[SZTagsViewCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    return _collectionView;
}

- (UIFont *)itemFont {
    return [UIFont systemFontOfSize:self.itemFontSize];
}

- (CGSize)getSizeWithContent:(NSString *)content maxWidth:(CGFloat)maxWidth customHeight:(CGFloat)cellHeight {
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize size = [content boundingRectWithSize:CGSizeMake(maxWidth - 20, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.itemFont,NSParagraphStyleAttributeName:style} context:nil].size;
    return CGSizeMake(size.width + 20, cellHeight);
}

@end
