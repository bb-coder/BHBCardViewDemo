//
//  BHBCardView.m
//  BHBCardViewDemo
//
//  Created by bihongbo on 15/11/14.
//  Copyright © 2015年 bihongbo. All rights reserved.
//

#import "BHBCardView.h"

@interface BHBCardView ()<UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray * allViews;

@property (nonatomic,strong) NSMutableArray * allViewInsets;


@end

@implementation BHBCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.pagingEnabled = YES;
        self.clipsToBounds = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = NO;
        _currentCardIndex = 0;
    }
    return self;
}

- (NSMutableArray *)allViews{
    if (!_allViews) {
        _allViews = [[NSMutableArray alloc] init];
    }
    return _allViews;
}

- (NSMutableArray *)allViewOffsets{
    if (!_allViewInsets) {
        _allViewInsets = [[NSMutableArray alloc] init];
    }
    return _allViewInsets;
    
}

- (void)setControllers:(NSArray *)controllers{
    [self clearAllViews];
    _controllers = controllers;
    [self addAllViews];
    
    if(self.controllers.count > 0)
    self.currentViewController = _controllers[_currentCardIndex];
    if(self.allViews.count > 0)
        self.currentView = _allViews[_currentCardIndex];
    
    CGRect vcFrame = CGRectZero;
    for (int i = 0; i < self.controllers.count; i ++) {
        UIViewController * vc = self.controllers[i];
        vcFrame = vc.view.bounds;
        vcFrame.origin.x = i * self.frame.size.width;
        vc.view.frame = vcFrame;
    }
    self.contentSize = CGSizeMake(self.frame.size.width * self.controllers.count, 0);
    
}

- (void)addObserverWith:(NSObject *)target{
    [target addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [target addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)removeObserverWith:(NSObject *)target{
    [target removeObserver:self forKeyPath:@"contentOffset"];
    [target removeObserver:self forKeyPath:@"contentSize"];
}

- (void)clearAllViews{
    [self.allViews removeAllObjects];
    [self.allViewOffsets removeAllObjects];
    for (UIViewController * vc in _controllers) {
        if ([vc.view isKindOfClass:[UIScrollView class]]) {
            [self removeObserverWith:vc.view];
        }else{
            for (UIView * obj in vc.view.subviews) {
                if ([obj isKindOfClass:[UIScrollView class]]) {
                    [self removeObserverWith:obj];
                    break;
                }
            }
        }
        [vc.view removeFromSuperview];
    }
}



- (void)addAllViews{

    for (UIViewController * vc in _controllers) {
        if ([vc.view isKindOfClass:[UIScrollView class]]) {
            [self addObserverWith:vc.view];
            [self.allViews addObject:vc.view];
            UIScrollView * sc = (UIScrollView *)vc.view;
            NSValue * cInset = [NSValue valueWithUIEdgeInsets:sc.contentInset];
            sc.bounces = YES;
            [self.allViewOffsets addObject:cInset];
        }else{
            for (UIView * obj in vc.view.subviews) {
                if ([obj isKindOfClass:[UIScrollView class]]) {
                    UIScrollView * sc = (UIScrollView *)obj;
                    NSValue * cInset = [NSValue valueWithUIEdgeInsets:sc.contentInset];
                    [self.allViewOffsets addObject:cInset];
                    [self addObserverWith:obj];
                    [self.allViews addObject:obj];
                    sc.bounces = YES;
                    break;
                }
            }
        }
        [self addSubview:vc.view];
    }

}

-(void)setTopInSetY:(CGFloat)topInSetY{
    _topInSetY = topInSetY;
    for (UIScrollView * sv in self.allViews) {
        sv.contentInset = UIEdgeInsetsMake(sv.contentInset.top + _topInSetY,sv.contentInset.left , sv.contentInset.bottom, sv.contentInset.right);
        [sv setContentOffset:CGPointMake(sv.contentOffset.x, - topInSetY - sv.contentInset.top) animated:YES];
    }
}

-(void)dealloc{
    [self clearAllViews];

}

-(void)setCommonOffsetY:(CGFloat)commonOffsetY{
    
    _commonOffsetY = commonOffsetY;
        for (UIScrollView * sc in self.allViews) {
            NSInteger index = [self.allViews indexOfObject:sc];
            UIEdgeInsets contentInset = [self.allViewOffsets[index] UIEdgeInsetsValue];
            if (sc != self.currentView) {
                if (sc.contentOffset.y + contentInset.top <= -self.topY) {
                sc.contentOffset = CGPointMake(sc.contentOffset.x, -commonOffsetY - contentInset.top);
                }
            }
            if (sc.contentOffset.y + contentInset.top <= -self.topY && sc.contentOffset.y + contentInset.top >=  -self.topInSetY) {
            sc.contentInset = UIEdgeInsetsMake((-sc.contentOffset.y),sc.contentInset.left , sc.contentInset.bottom, sc.contentInset.right);
            }
            else if(sc.contentOffset.y + contentInset.top > -self.topY){
                sc.contentInset = UIEdgeInsetsMake((self.topY + contentInset.top),sc.contentInset.left , sc.contentInset.bottom, sc.contentInset.right);
            }
            else if(sc.contentOffset.y + contentInset.top < -self.topInSetY){
                sc.contentInset = UIEdgeInsetsMake((self.topInSetY + contentInset.top),sc.contentInset.left , sc.contentInset.bottom, sc.contentInset.right);
            }
        }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint oldP = [change[@"old"] CGPointValue];
        CGPoint newP = [change[@"new"] CGPointValue];
        if(object == self.currentView){
            if (self.cardViewDelegate && [self.cardViewDelegate respondsToSelector:@selector(cardViewScroll:didScrollWithOffsetOld:andOffetNew:)]) {
                [self.cardViewDelegate cardViewScroll:object didScrollWithOffsetOld:oldP andOffetNew:newP];
            }
        }
    }
    else if([keyPath isEqualToString:@"contentSize"]){
        if ([object isKindOfClass:[UIScrollView class]]) {
            UIScrollView * scr = object;
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(adjustContentSize:) object:scr];
                [self performSelector:@selector(adjustContentSize:) withObject:scr afterDelay:.1];
        }
    }
}

- (void)adjustContentSize:(UIScrollView *)scr{
    NSInteger index = [self.allViews indexOfObject:scr];
    UIEdgeInsets contentTopInset = [[self.allViewOffsets objectAtIndex:index] UIEdgeInsetsValue];
    if (scr.contentSize.height < scr.bounds.size.height - contentTopInset.top - self.topY) {
        scr.contentSize = CGSizeMake(0, scr.bounds.size.height - contentTopInset.top - self.topY);
    }

}

-(void)setCurrentCardIndex:(NSInteger)currentCardIndex{
    
    _currentCardIndex = currentCardIndex;
    self.currentViewController = self.controllers[currentCardIndex];
    self.currentView = self.allViews[currentCardIndex];
    [self setContentOffset:CGPointMake(self.frame.size.width * _currentCardIndex, 0) animated:YES];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self && ((int)scrollView.contentOffset.x % (int)self.frame.size.width) == 0 && (int)scrollView.contentOffset.x == scrollView.contentOffset.x) {
        NSInteger index = scrollView.contentOffset.x / self.frame.size.width;
        if(self.currentCardIndex == index)return;
        self.currentCardIndex = index;
        if (self.cardViewDelegate && [self.cardViewDelegate respondsToSelector:@selector(carViewDidScrollToIndex:)]) {
            [self.cardViewDelegate carViewDidScrollToIndex:index];
        }
    }
}



@end
