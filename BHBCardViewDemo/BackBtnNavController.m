//
//  BackBtnNavController.m
//  BHBCardViewDemo
//
//  Created by bihongbo on 15/11/28.
//  Copyright © 2015年 bihongbo. All rights reserved.
//

#import "BackBtnNavController.h"
#import <objc/runtime.h>

@implementation BackBtnNavController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if(self){
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    rootViewController.navigationItem.leftBarButtonItem = back;
    }
    return self;
    
}

- (void)back{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end


@implementation UINavigationBar (backgroundColor)

static char bhbOverlayKey;

- (UIView *)bhbOverlayView{
    return objc_getAssociatedObject(self, &bhbOverlayKey);
}

- (void)setBhbOverlayView:(UIView *)bhbOverlayView{
    objc_setAssociatedObject(self, &bhbOverlayKey, bhbOverlayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)bhb_setBackgroundColor:(UIColor *)color{
    if (!self.bhbOverlayView) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:[UIImage new]];
        self.bhbOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
        [self insertSubview:self.bhbOverlayView atIndex:0];
    }
    self.bhbOverlayView.backgroundColor = color;
}

@end
