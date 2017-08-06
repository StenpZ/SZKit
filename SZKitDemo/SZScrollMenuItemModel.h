//
//  SZScrollMenuItemModel.h
//  SZKitDemo
//
//  Created by zxc on 2017/8/4.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZScrollMenu.h"

@interface SZScrollMenuItemModel : NSObject<SZMenuItemObject>

@property(nonatomic, copy) NSString *text;

@property(nonatomic, strong) id image;

@property(nonatomic, strong) UIImage *placeholderImage;

@end
