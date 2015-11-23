//
//  BHBCardView.h
//  BHBCardViewDemo
//
//  Created by bihongbo on 15/11/14.
//  Copyright © 2015年 bihongbo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BHBCardView;

@protocol BHBCardViewDelegate <NSObject>

- (void)cardViewScroll:(UIScrollView *)scollView didScrollWithOffsetOld:(CGPoint)offsetOld andOffetNew:(CGPoint)offsetNew;

@optional
- (void)carViewDidScrollToIndex:(NSInteger)index;

@end

@interface BHBCardView : UIScrollView

@property (nonatomic, weak) id<BHBCardViewDelegate> cardViewDelegate;

@property (nonatomic, strong) NSArray * controllers;

@property (nonatomic, weak) UIViewController * currentViewController;

@property (nonatomic, assign) NSInteger currentCardIndex;

@property (nonatomic, assign) CGFloat topInSetY;

@property (nonatomic, assign) CGFloat topY;

@property (nonatomic, assign) CGFloat commonOffsetY;

@property (nonatomic,strong ,readonly) NSMutableArray * allViewOffsets;

@property (nonatomic,strong ,readonly) NSMutableArray * allViews;

@property (nonatomic,weak) UIView * currentView;



@end
