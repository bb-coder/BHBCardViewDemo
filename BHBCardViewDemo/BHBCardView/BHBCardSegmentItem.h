//
//  BHBCardSegmentItem.h
//  BHBCardViewDemo
//
//  Created by bihongbo on 15/11/14.
//  Copyright © 2015年 bihongbo. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface BHBCardSegmentItem : NSObject

@property (nonatomic, assign) CGSize size;

@property (nonatomic, copy) NSString * title;

@property (nonatomic, strong) UIColor * titleColor;

@property (nonatomic, strong) UIColor * selectTitleColor;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, strong) UIFont * titleFont;

@property (nonatomic, assign) CGRect contentFrame;

@property (nonatomic, strong ,readonly) UIView  * customView;

- (instancetype)initWithCustomView:(UIView *)customView;

@end
