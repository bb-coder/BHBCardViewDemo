//
//  ViewController.m
//  BHBCardViewDemo
//
//  Created by bihongbo on 15/11/18.
//  Copyright © 2015年 bihongbo. All rights reserved.
//

#import "ViewController.h"
#import "AnimationController.h"
#import "NomalViewController.h"

@implementation ViewController

-(void)viewDidLoad{
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"开启动画" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(aniStart) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(200, 200, 100, 50);
    [self.view addSubview:btn];
    
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"关闭动画" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(normalStart) forControlEvents:UIControlEventTouchUpInside];
    btn1.frame = CGRectMake(200, 400, 100, 50);
    [self.view addSubview:btn1];
    
    
    
}

- (void)aniStart{
    AnimationController * a =[[AnimationController alloc]init];
    [self presentViewController:a animated:NO completion:nil];
}

- (void)normalStart{
    NomalViewController * a =[[NomalViewController alloc]init];
    [self presentViewController:a animated:NO completion:nil];
}

@end
