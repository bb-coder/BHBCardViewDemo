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

@property (nonatomic,strong) NSMutableArray * allViewOffsets;


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
    if (!_allViewOffsets) {
        _allViewOffsets = [[NSMutableArray alloc] init];
    }
    return _allViewOffsets;
    
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
        vcFrame = self.bounds;
        vcFrame.origin.x = i * self.frame.size.width;
        vc.view.frame = vcFrame;
    }
    self.contentSize = CGSizeMake(self.frame.size.width * self.controllers.count, 0);
    
}

- (void)addObserverWith:(NSObject *)target{
    [target addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)removeObserverWith:(NSObject *)target{
    [target removeObserver:self forKeyPath:@"contentOffset"];
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
            [self.allViewOffsets addObject:cInset];
        }else{
            for (UIView * obj in vc.view.subviews) {
                if ([obj isKindOfClass:[UIScrollView class]]) {
                    UIScrollView * sc = (UIScrollView *)obj;
                    NSValue * cInset = [NSValue valueWithUIEdgeInsets:sc.contentInset];
                    [self.allViewOffsets addObject:cInset];
                    [self addObserverWith:obj];
                    [self.allViews addObject:obj];
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
//        sv.bounds = CGRectMake(0, -topInSetY, sv.frame.size.width, sv.frame.size.height);
//        [sv setContentOffset:CGPointMake(sv.contentOffset.x, - topInSetY) animated:YES];
    }
}

-(void)dealloc{
    [self clearAllViews];

}

-(void)setCommonOffsetY:(CGFloat)commonOffsetY{
    
    _commonOffsetY = commonOffsetY;
        for (UIScrollView * sc in self.allViews) {
            if (sc != self.currentView) {
                NSInteger index = [self.allViews indexOfObject:sc];
                UIEdgeInsets contentInset = [self.allViewOffsets[index] UIEdgeInsetsValue];
                if (sc.contentOffset.y - contentInset.top <= -self.topY) {
                    sc.contentOffset = CGPointMake(sc.contentOffset.x, -commonOffsetY - contentInset.top);
                }
            }
        }
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    CGPoint oldP = [change[@"old"] CGPointValue];
    CGPoint newP = [change[@"new"] CGPointValue];
    
    if(object == self.currentView){
//        NSLog(@"view:%@---change:%@",object,change);
//        if((-newP.y <= self.topInSetY && -newP.y >= self.topY)){
//        CGFloat deltaY = newP.y - oldP.y;
//        }
    if (self.cardViewDelegate && [self.cardViewDelegate respondsToSelector:@selector(cardViewScroll:didScrollWithOffsetOld:andOffetNew:)]) {
        [self.cardViewDelegate cardViewScroll:object didScrollWithOffsetOld:oldP andOffetNew:newP];
    }
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
