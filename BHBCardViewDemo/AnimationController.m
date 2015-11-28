//
//  AnimationController.m
//  BHBCardViewDemo
//
//  Created by bihongbo on 15/11/18.
//  Copyright © 2015年 bihongbo. All rights reserved.
//

#define defautColor [UIColor colorWithRed:117/255.0 green:211/255.0 blue:23/255.0 alpha:1]

#import "AnimationController.h"
#import "BHBCardViewController.h"
#import "TableViewController.h"
#import "ImageViewController.h"
#import "CollectionViewController.h"
#import "BackBtnNavController.h"

@interface AnimationController ()<BHBCardViewControllerDataSource,BHBCardViewControllerDelegate>

@end

@implementation AnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"点击有吸顶";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar bhb_setBackgroundColor:[defautColor colorWithAlphaComponent:0]];
    
    BHBCardViewController * cvc = [[BHBCardViewController alloc]init];
    cvc.dataSource = self;
    cvc.delegate = self;
    cvc.scrollTopAnimationable = YES;
    cvc.topY = 64;
    cvc.currentIndex = 1;
    [self.view addSubview:cvc.view];
    [self addChildViewController:cvc];
}

-(BHBCardHeaderView *)cardViewControllerCustomHeaderView{
    BHBCardHeaderView * headerView = [[BHBCardHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 349)];
    UIImageView * topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 349)];
    topView.contentMode = UIViewContentModeScaleAspectFill;
    topView.image = [UIImage imageNamed:@"1"];
    topView.clipsToBounds = YES;
    [headerView addSubview:topView];
    return headerView;
    
}

-(NSArray *)cardViewControllerSubControllers{
    TableViewController * tv = [[TableViewController alloc]init];
    CollectionViewController * iv = [[CollectionViewController alloc]init];
    ImageViewController * iv1 =[[ImageViewController alloc]init];
    return @[tv,iv,iv1];
}

-(BHBCardSegmentView *)cardViewControllerSegmentView{
    BHBCardSegmentView * seView = [[BHBCardSegmentView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49)];
    BHBCardSegmentItem * item1 = [[BHBCardSegmentItem alloc]initWithCustomView:nil];
    item1.title = @"表格";
    BHBCardSegmentItem * item2 = [[BHBCardSegmentItem alloc]init];
    item2.title = @"美女";
    BHBCardSegmentItem * item3 = [[BHBCardSegmentItem alloc]init];
    item3.title = @"滚动";
    seView.items = @[item1,item2,item3];
    return seView;
}

-(void)cardViewHeaderView:(BHBCardHeaderView *)headerView DidDisplayOrNot:(BOOL)isDisplay{
    [self.navigationController.navigationBar bhb_setBackgroundColor:[defautColor colorWithAlphaComponent:(-headerView.frame.origin.y) / (headerView.frame.size.height - headerView.segmentView.frame.size.height - 64)]];
    if(isDisplay){
        NSLog(@"显示header");
    }
    else{
        NSLog(@"header出屏幕");
    }
    
}


@end
