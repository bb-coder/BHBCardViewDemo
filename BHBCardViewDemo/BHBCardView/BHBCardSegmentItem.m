//
//  BHBCardSegmentItem.m
//  BHBCardViewDemo
//
//  Created by bihongbo on 15/11/14.
//  Copyright © 2015年 bihongbo. All rights reserved.
//

#import "BHBCardSegmentItem.h"

@interface BHBCardSegmentItem ()

@property (nonatomic,strong) UIView * customView;

@property (nonatomic, strong) UIFont * titleFont;

@end

@implementation BHBCardSegmentItem

@synthesize size = _size;

- (instancetype)initWithCustomView:(UIView *)customView{
    
    self = [self init];

    if(customView)
    self.customView = customView;
    
    return self;
}

- (instancetype)init{
    self = [super init];
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.userInteractionEnabled = NO;
        self.customView = btn;
        self.selected = NO;
        self.titleColor = [UIColor grayColor];
        self.selectTitleColor = [UIColor greenColor];
        [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectTitleColor forState:UIControlStateSelected];

    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    
    if ([self.customView isKindOfClass:[UIButton class]]) {
        UIButton * lbl = (UIButton *)self.customView;
        [lbl setTitle:title forState:UIControlStateNormal];
    }
}

-(void)setSelected:(BOOL)selected{
    _selected = selected;
    if ([self.customView isKindOfClass:[UIButton class]]) {
        UIButton * lb = (UIButton *)self.customView;
        lb.selected = _selected;
    }
    
}


-(UIFont *)titleFont{
    if([self.customView respondsToSelector:@selector(font)])
    return [(id)self.customView font];
    return nil;
}

- (CGRect)contentFrame{
    
    if(CGRectIsEmpty(_contentFrame))
    _contentFrame = [self.title boundingRectWithSize:CGSizeMake(self.size.width, self.size.height) options:0 attributes:@{NSFontAttributeName:self.titleFont} context:nil];
    
    return _contentFrame;
    
}



- (CGSize)size{
    
    return self.customView.frame.size;
    
}

- (void)setSize:(CGSize)size{
    
    _size = size;
    
    self.customView.frame = CGRectMake(self.customView.frame.origin.x, self.customView.frame.origin.y, _size.width, _size.height);
    
}

@end
