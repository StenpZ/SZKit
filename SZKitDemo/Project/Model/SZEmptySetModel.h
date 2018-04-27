//
//  SZEmptySetModel.h
//  SZKitDemo
//
//  Created by StenpZ on 2018/4/26.
//  Copyright © 2018年 StenpZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZEmptySetModel : NSObject

@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *text;
/// 是否需要展示
@property(nonatomic) BOOL showEmptySet;

@end
