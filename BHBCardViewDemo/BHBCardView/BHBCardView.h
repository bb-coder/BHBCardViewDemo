//
//  BHBCardView.h
//  BHBCardViewDemo
//
//  Created by bihongbo on 15/11/14.
//  Copyright © 2015年 bihongbo. All rights reserved.
//  BLOG:http://bihongbo.com
//  GitHub:https://github.com/bb-coder
//

#import <UIKit/UIKit.h>
@class BHBCardView;

@protocol BHBCardViewDelegate <NSObject>
/**
 *  滚动回调
 */
- (void)cardViewScroll:(UIScrollView *)scollView didScrollWithOffsetOld:(CGPoint)offsetOld andOffetNew:(CGPoint)offsetNew;

@optional
/**
 *  切换到某一个控制器的回调
 */
- (void)carViewDidScrollToIndex:(NSInteger)index;

@end

@interface BHBCardView : UIScrollView

@property (nonatomic, weak) id<BHBCardViewDelegate> cardViewDelegate;//代理
@property (nonatomic, strong) NSArray * controllers;//所有的内容控制器
@property (nonatomic, weak) UIViewController * currentViewController;//当前的控制器
@property (nonatomic,strong ,readonly) NSMutableArray * allViews;//显示的所有视图
@property (nonatomic, assign) NSInteger currentCardIndex;//当前的索引
@property (nonatomic,weak) UIView * currentView;//当前视图

@property (nonatomic, assign) CGFloat topInSetY;//顶部视图的高度
@property (nonatomic, assign) CGFloat topY;//segmentview的高度
@property (nonatomic, assign) CGFloat commonOffsetY;//公共的顶部视图位移

@property (nonatomic,strong ,readonly) NSMutableArray * allViewInsets;//保存每一个滚动视图的contentInset




@end
