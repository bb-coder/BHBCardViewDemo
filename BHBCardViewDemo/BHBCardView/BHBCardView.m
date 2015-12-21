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

- (NSMutableArray *)allViewInsets{
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
        vcFrame = self.bounds;
        vcFrame.origin.x = i * self.frame.size.width;
        vc.view.frame = vcFrame;
    }
    self.contentSize = CGSizeMake(self.frame.size.width * self.controllers.count, 0);
    
}

- (void)addObserverWith:(NSObject *)target{
    [target addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    if ([target isMemberOfClass:[UICollectionView class]]) {
        return;
    }
    [target addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)removeObserverWith:(NSObject *)target{
    [target removeObserver:self forKeyPath:@"contentOffset"];
    if ([target isMemberOfClass:[UICollectionView class]]) {
        return;
    }
    [target removeObserver:self forKeyPath:@"contentSize"];
}

- (void)clearAllViews{
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
    int i = 0;
    
    for (UIScrollView * scr in self.allViews) {
        scr.contentInset = [self.allViewInsets[i] UIEdgeInsetsValue];
        scr.contentOffset = CGPointMake(0, scr.contentInset.top);
        i++;
    }
    [self.controllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    [self.allViews removeAllObjects];
    [self.allViewInsets removeAllObjects];
    
}



- (void)addAllViews{

    for (UIViewController * vc in _controllers) {
        if ([vc.view isKindOfClass:[UIScrollView class]]) {
            [self addObserverWith:vc.view];
            [self.allViews addObject:vc.view];
            UIScrollView * sc = (UIScrollView *)vc.view;
            NSValue * cInset = [NSValue valueWithUIEdgeInsets:sc.contentInset];
            sc.bounces = NO;
            [self.allViewInsets addObject:cInset];
        }else{
            for (UIView * obj in vc.view.subviews) {
                if ([obj isKindOfClass:[UIScrollView class]]) {
                    UIScrollView * sc = (UIScrollView *)obj;
                    NSValue * cInset = [NSValue valueWithUIEdgeInsets:sc.contentInset];
                    [self.allViewInsets addObject:cInset];
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
        //        [vc.view removeFromSuperview];
    }


}

-(void)setCommonOffsetY:(CGFloat)commonOffsetY{
    
    _commonOffsetY = commonOffsetY;
    for (UIScrollView * sc in self.allViews) {
        NSInteger index = [self.allViews indexOfObject:sc];
        UIEdgeInsets contentInset = [self.allViewInsets[index] UIEdgeInsetsValue];
        if (sc != self.currentView) {
            if (sc.contentOffset.y + contentInset.top <= -self.topY) {
                sc.contentOffset = CGPointMake(sc.contentOffset.x, -commonOffsetY - contentInset.top);
            }
        }
        if ([sc isMemberOfClass:[UICollectionView class]]) {
            continue;
        }
        if (sc.contentOffset.y + contentInset.top <= -self.topY && sc.contentOffset.y + contentInset.top >=  -self.topInSetY) {
            if(sc.contentInset.top != (-sc.contentOffset.y))
                sc.contentInset = UIEdgeInsetsMake((-sc.contentOffset.y),sc.contentInset.left , sc.contentInset.bottom, sc.contentInset.right);
        }
        else if(sc.contentOffset.y + contentInset.top > -self.topY){
            if(sc.contentInset.top != (self.topY + contentInset.top))
                sc.contentInset = UIEdgeInsetsMake((self.topY + contentInset.top),sc.contentInset.left , sc.contentInset.bottom, sc.contentInset.right);
        }
        else if(sc.contentOffset.y + contentInset.top < -self.topInSetY){
            if(sc.contentInset.top != (self.topInSetY + contentInset.top))
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
    if(![self.allViews containsObject:scr])return;
    UIEdgeInsets contentTopInset = [[self.allViewInsets objectAtIndex:index] UIEdgeInsetsValue];
    if (scr.contentSize.height < scr.bounds.size.height - contentTopInset.top - self.topY) {
        scr.contentSize = CGSizeMake(0, scr.bounds.size.height - contentTopInset.top - self.topY);
    }

}

-(void)setCurrentCardIndex:(NSInteger)currentCardIndex{
    
    _currentCardIndex = currentCardIndex;
    self.currentViewController = self.controllers[currentCardIndex];
    if(_allViews.count > currentCardIndex)
    self.currentView = self.allViews[currentCardIndex];
    [self setContentOffset:CGPointMake(self.frame.size.width * _currentCardIndex, 0) animated:YES];
    
}


- (void)setDefautIndex:(NSInteger)index{
    
    _currentCardIndex = index;
    self.currentViewController = self.controllers[index];
    if(_allViews.count > index)
    self.currentView = self.allViews[index];
    [self setContentOffset:CGPointMake(self.frame.size.width * _currentCardIndex, 0) animated:NO];
    
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
