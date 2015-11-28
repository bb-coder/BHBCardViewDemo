//
//  BHBCardSegmentView.h
//  BHBCardViewDemo
//
//  Created by bihongbo on 15/11/13.
//  Copyright © 2015年 bihongbo. All rights reserved.
//  BLOG:http://bihongbo.com
//  GitHub:https://github.com/bb-coder
//

#import <UIKit/UIKit.h>
#import "BHBCardSegmentItem.h"

@protocol BHBCardSegmentViewDelegate <NSObject>

@optional
/**
 *  选中某一个item之后的回调
 */
- (void)cardSegmentViewDidSelectIndex:(NSInteger)index;

@end

@interface BHBCardSegmentView : UIView

@property (nonatomic, weak) id<BHBCardSegmentViewDelegate> delegate;//代理
@property (nonatomic, strong) NSArray<BHBCardSegmentItem *> * items;//所有的items，它们会依次显示在segmentview上

@property (nonatomic, assign) UIEdgeInsets itemInset;//item的内边距
@property (nonatomic, assign) NSInteger currentIndex;//当前所在的item索引
@property (nonatomic, assign) BOOL showBottomLine;//是否显示底部的线
@property (nonatomic, assign) BOOL isAutoLineWidth;//底部显示的线是否跟随文字内容的宽度动态设置

@end
