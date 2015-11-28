//
//  ViewController.h
//  BHBCardViewDemo
//
//  Created by bihongbo on 15/11/13.
//  Copyright © 2015年 bihongbo. All rights reserved.
//  BLOG:http://bihongbo.com
//  GitHub:https://github.com/bb-coder

#import <UIKit/UIKit.h>
#import "BHBCardSegmentView.h"
#import "BHBCardView.h"
#import "BHBCardHeaderView.h"


@protocol BHBCardViewControllerDelegate <NSObject>

@optional
/**
 *  顶部视图是否显示出来，每当顶部视图位置发生变化的时候调用此回调
 *
 *  @param headerView 顶部视图
 *  @param isDisplay  是否显示
 */
- (void)cardViewHeaderView:(BHBCardHeaderView *)headerView DidDisplayOrNot:(BOOL)isDisplay;

@end

@protocol BHBCardViewControllerDataSource <NSObject>

@optional
/**
 *  数据源方法，返回自定义的头部视图，无返回自动创建默认与segment等宽高的头部视图。
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

@property (nonatomic, weak) id<BHBCardViewControllerDataSource> dataSource;//数据源属性，通过设置它来提供所要显示的数据，通过cardViewControllerCustomHeaderView、cardViewControllerSubControllers、cardViewControllerSegmentView三个数据源方法来加载头部、底部控制器、中间segment选择控制视图。
@property (nonatomic, weak) id<BHBCardViewControllerDelegate> delegate;//代理方法，目前只有一个cardViewHeaderView: DidDisplayOrNot:方法来监控头部视图是否出现。

@property (nonatomic, strong, readonly) BHBCardHeaderView * headerView;//头部视图
@property (nonatomic, strong, readonly) NSArray * controllers;//所有子控制器
@property (nonatomic, strong, readonly) BHBCardSegmentView * segmentView;//选项控制视图
@property (nonatomic, strong, readonly) BHBCardView * cardView;//底部分页视图

@property (nonatomic, assign) CGRect frame;//BHBCardViewController所持有的view的frame并不利于你的布局，在你需要更改它的大小的时候，请用BHBCardViewController的frame属性来设置大小。

@property (nonatomic, assign) NSInteger currentIndex;//可读取当前所选中的索引值，设置默认的索引值只需要设置它即可。

@property (nonatomic, assign) BOOL scrollTopAnimationable;//点击选项控制视图是否具有发生吸顶动画的能力。

@property (nonatomic, assign) CGFloat topY;//顶部吸顶距离，比如说你的视图上面有导航栏，它可以是64用来吸住导航栏底部。


/**
 *  刷新数据方法，会触发视图重新布局
 */
- (void)reloadData;

@end

