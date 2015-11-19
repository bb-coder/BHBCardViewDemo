//
//  BHBCardSegmentView.h
//  BHBCardViewDemo
//
//  Created by bihongbo on 15/11/13.
//  Copyright © 2015年 bihongbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHBCardSegmentItem.h"

@protocol BHBCardSegmentViewDelegate <NSObject>

@optional
- (void)cardSegmentViewDidSelectIndex:(NSInteger)index;

@end

@interface BHBCardSegmentView : UIView

@property (nonatomic, weak) id<BHBCardSegmentViewDelegate> delegate;

@property (nonatomic, strong) NSArray<BHBCardSegmentItem *> * items;

@property (nonatomic, assign) UIEdgeInsets itemInset;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) BOOL showBottomLine;

@property (nonatomic, assign) BOOL isAutoLineWidth;

@end
