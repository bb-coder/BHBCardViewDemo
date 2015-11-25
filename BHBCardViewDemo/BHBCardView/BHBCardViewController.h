//
//  ViewController.h
//  BHBCardViewDemo
//
//  Created by bihongbo on 15/11/13.
//  Copyright © 2015年 bihongbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHBCardSegmentView.h"
#import "BHBCardView.h"
#import "BHBCardHeaderView.h"


@protocol BHBCardViewControllerDelegate <NSObject>

@optional

- (void)cardViewHeaderView:(BHBCardHeaderView *)headerView DidDisplayOrNot:(BOOL)isDisplay;

@end

@protocol BHBCardViewControllerDataSource <NSObject>

@optional
/**
 *  数据源方法，返回自定义的头部视图，无返回自动
 *
 *  @return 自定义顶部视图
 */
- (BHBCardHeaderView *)cardViewControllerCustomHeaderView;

@required
/**
 *  数据源方法，返回控制器集合
 *
 *  @return 控制器集合
 */
- (NSArray *)cardViewControllerSubControllers;
/**
 *  数据源方法，返回卡片控制视图
 *
 *  @return 卡片控制视图
 */
- (BHBCardSegmentView *)cardViewControllerSegmentView;

@end

@interface BHBCardViewController : UIViewController

@property (nonatomic, weak) id<BHBCardViewControllerDataSource> dataSource;

@property (nonatomic, weak) id<BHBCardViewControllerDelegate> delegate;

@property (nonatomic, strong, readonly) BHBCardHeaderView * headerView;

@property (nonatomic, strong, readonly) NSArray * controllers;

@property (nonatomic, strong, readonly) BHBCardSegmentView * segmentView;

@property (nonatomic, strong, readonly) BHBCardView * cardView;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) BOOL scrollTopAnimationable;

- (void)reloadData;

@end

