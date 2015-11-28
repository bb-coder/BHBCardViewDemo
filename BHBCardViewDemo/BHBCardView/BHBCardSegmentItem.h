//
//  BHBCardSegmentItem.h
//  BHBCardViewDemo
//
//  Created by bihongbo on 15/11/14.
//  Copyright © 2015年 bihongbo. All rights reserved.
//  BLOG:http://bihongbo.com
//  GitHub:https://github.com/bb-coder
//
#import <UIKit/UIKit.h>

@interface BHBCardSegmentItem : NSObject

@property (nonatomic, assign) CGSize size;//item的大小

@property (nonatomic, copy) NSString * title;//默认的title，如果有设置customview，请无视它
@property (nonatomic, strong) UIColor * titleColor;//默认的titleColor，如果有设置customview，请无视它
@property (nonatomic, strong) UIColor * selectTitleColor;//默认的selectTitleColor，如果有设置customview，请无视它
@property (nonatomic, strong ,readonly) UIFont * titleFont;//默认的titleFont，如果有设置customview，请无视它

@property (nonatomic, assign) BOOL selected;//选中状态
@property (nonatomic, assign) CGRect contentFrame;//内容大小

@property (nonatomic, strong ,readonly) UIView  * customView;//自定义的视图

/**
 *  快速创建一个segmentitem
 *
 *  @param customView 自定义的视图，它最终会显示在segmentview上，如果想使用默认，请传nil
 *
 */
- (instancetype)initWithCustomView:(UIView *)customView;

@end
