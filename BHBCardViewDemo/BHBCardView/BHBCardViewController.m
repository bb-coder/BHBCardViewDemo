//
//  ViewController.m
//  BHBCardViewDemo
//
//  Created by bihongbo on 15/11/13.
//  Copyright © 2015年 bihongbo. All rights reserved.
//

#import "BHBCardViewController.h"

@interface BHBCardViewController ()<BHBCardViewDelegate,BHBCardSegmentViewDelegate>

@property (nonatomic,strong) BHBCardView * cardView;

@property (nonatomic, strong) BHBCardHeaderView * headerView;

@property (nonatomic, strong) NSArray * controllers;

@property (nonatomic, strong) BHBCardSegmentView * segmentView;

@end

@implementation BHBCardViewController

- (void)reloadData{
    if (!CGRectIsEmpty(self.frame)) {
        self.view.frame = self.frame;
    }else{
        self.frame = self.view.frame;
    }
    [self.cardView.controllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    [self.cardView clearAllViews];
    [self.cardView removeFromSuperview];
    [self.headerView removeFromSuperview];
    self.cardView = nil;
    self.headerView = nil;
    self.controllers = nil;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(cardViewControllerSegmentView)]) {
        self.segmentView = [self.dataSource cardViewControllerSegmentView];
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(cardViewControllerCustomHeaderView)]) {
        self.headerView = [self.dataSource cardViewControllerCustomHeaderView];
    }
    
    if(!self.headerView){
        self.headerView = [[BHBCardHeaderView alloc]initWithFrame:self.segmentView.bounds];
    }
    self.headerView.userInteractionEnabled = YES;
    [self.view addSubview:self.headerView];
    self.segmentView.delegate = self;
    self.segmentView.frame = CGRectMake(self.segmentView.frame.origin.x, self.headerView.frame.size.height - self.segmentView.frame.size.height, self.segmentView.frame.size.width, self.segmentView.frame.size.height);
    self.segmentView.userInteractionEnabled = YES;
    [self.headerView addSubview:self.segmentView];
    self.headerView.segmentView = self.segmentView;
    if(!self.cardView){
      self.cardView = [[BHBCardView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    else{
        self.cardView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    self.cardView.cardViewDelegate = self;
    self.cardView.topY = self.segmentView.frame.size.height + self.topY;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(cardViewControllerSubControllers)]) {
        self.cardView.controllers = [self.dataSource cardViewControllerSubControllers];
        [self.cardView.controllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIViewController * vc = (UIViewController *)obj;
            [self addChildViewController:vc];
        }];
    }
    [self.segmentView setSelectItem:_currentIndex];
    [self.cardView setDefautIndex:_currentIndex];
    self.cardView.topInSetY = self.headerView.frame.size.height;
    self.cardView.commonOffsetY = self.headerView.frame.size.height;
    [self.view addSubview:self.cardView];
    [self.view bringSubviewToFront:self.headerView];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    
    _currentIndex = currentIndex;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cardViewHeaderView:DidSelectCurrentIndex:)]) {
        [self.delegate cardViewHeaderView:self.headerView DidSelectCurrentIndex:_currentIndex];
    }
}

- (void)carViewDidScrollToIndex:(NSInteger)index{
    self.segmentView.currentIndex = index;
    self.currentIndex = index;
}

- (void)scrollTopAnimation{

    UIScrollView * sc = (UIScrollView *)self.cardView.currentView;
    NSInteger index = [self.cardView.allViews indexOfObject:sc];
    UIEdgeInsets contentInset = [self.cardView.allViewInsets[index] UIEdgeInsetsValue];
    [sc setContentOffset:CGPointMake(0, -self.cardView.topY - contentInset.top) animated:YES];
}

-(void)cardSegmentViewDidSelectIndex:(NSInteger)index{
    self.cardView.currentCardIndex = index;
    self.currentIndex = index;
    if (self.scrollTopAnimationable) {
        [self scrollTopAnimation];
    }
}


-(void)cardViewScroll:(UIScrollView *)scollView didScrollWithOffsetOld:(CGPoint)offsetOld andOffetNew:(CGPoint)offsetNew{
    if (!self.cardView || !self.headerView) {
        return;
    }
    NSInteger index = [self.cardView.allViews indexOfObject:scollView];
    if (self.cardView.allViewInsets.count < index) {
        return;
    }
    UIEdgeInsets contentInset = [self.cardView.allViewInsets[index] UIEdgeInsetsValue];
        CGFloat headerTargetY = -(offsetNew.y + contentInset.top + self.cardView.topInSetY);
        if (headerTargetY <= 0 && headerTargetY >= -(self.cardView.topInSetY - self.cardView.topY)) {
            self.headerView.frame = CGRectMake(self.headerView.frame.origin.x,headerTargetY, self.headerView.frame.size.width, self.headerView.frame.size.height);
        }
        else if(headerTargetY < -self.cardView.topY){
            [UIView animateWithDuration:.25 animations:^{
                self.headerView.frame = CGRectMake(self.headerView.frame.origin.x,-(self.cardView.topInSetY - self.cardView.topY), self.headerView.frame.size.width, self.headerView.frame.size.height);
            }];
        }else if(headerTargetY > 0){
            [UIView animateWithDuration:.25 animations:^{
                self.headerView.frame = CGRectMake(self.headerView.frame.origin.x,0, self.headerView.frame.size.width, self.headerView.frame.size.height);
            }];
        }
    if(self.cardView.commonOffsetY != self.headerView.frame.origin.y + self.headerView.frame.size.height){
        self.cardView.commonOffsetY = self.headerView.frame.origin.y + self.headerView.frame.size.height;
        if (floor(self.cardView.commonOffsetY) > self.cardView.topY) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(cardViewHeaderView:DidDisplayOrNot:)]) {
                [self.delegate cardViewHeaderView:self.headerView DidDisplayOrNot:YES];
            }
        }else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(cardViewHeaderView:DidDisplayOrNot:)]) {
                [self.delegate cardViewHeaderView:self.headerView DidDisplayOrNot:NO];
            }
            
        }
    }
    
    
//    }
    
}

@end
