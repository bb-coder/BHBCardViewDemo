//
//  BHBCardHeaderView.m
//  BHBCardViewDemo
//
//  Created by bihongbo on 15/11/18.
//  Copyright © 2015年 bihongbo. All rights reserved.
//

#import "BHBCardHeaderView.h"
#import "BHBCardSegmentView.h"

@implementation BHBCardHeaderView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    if ([self pointInside:point withEvent:event]) {
    
        for (UIView * subView in self.subviews) {
            if (([subView isKindOfClass:[BHBCardSegmentView class]] || subView.gestureRecognizers.count > 0 || [subView isKindOfClass:[UIControl class]]) && subView.userInteractionEnabled) {
                CGPoint convertPoint = [subView convertPoint:point fromView:self];
                if ([subView pointInside:convertPoint withEvent:event]) {
                    return [super hitTest:point withEvent:event];
                }
            }
        }
        return nil;
    }
    return nil;
}

@end
