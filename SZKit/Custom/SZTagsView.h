//
//  SZTagsView.h
//  SZKitDemo
//
//  Created by StenpZ on 2018/1/15.
//  Copyright © 2018年 StenpZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SZTagsView;

@protocol SZTagsViewProtocol <NSObject>

- (NSInteger)numberOfItemsInTagsView:(SZTagsView *)tagsView;

- (NSString *)tagsView:(SZTagsView *)tagsView titleForItemAtIndex:(NSInteger)index;

@optional
- (void)tagsView:(SZTagsView *)tagsView didSelectItemAtIndex:(NSInteger)index;

- (void)tagsView:(SZTagsView *)tagsView heightUpdated:(CGFloat)height;

@end


@interface SZTagsView : UIView


@property(nonatomic) CGFloat itemFontSize;
@property(nonatomic, strong) UIColor *itemTextColor;
@property(nonatomic, strong) UIColor *itemBackgroundColor;

@property(nonatomic) NSInteger tagCornerRadius;

@property(nonatomic) CGFloat cellHeight;

@property(nonatomic, weak) id<SZTagsViewProtocol> delegate;

- (void)reloadData;

@end
