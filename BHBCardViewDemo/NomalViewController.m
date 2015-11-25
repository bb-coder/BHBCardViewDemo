//
//  ViewController.m
//  BHBCardViewDemo
//
//  Created by bihongbo on 15/11/18.
//  Copyright © 2015年 bihongbo. All rights reserved.
//

#import "NomalViewController.h"
#import "BHBCardViewController.h"
#import "TableViewController.h"
#import "ImageViewController.h"

@interface NomalViewController ()<BHBCardViewControllerDataSource,BHBCardViewControllerDelegate>

@end

@implementation NomalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BHBCardViewController * cvc = [[BHBCardViewController alloc]init];
    cvc.dataSource = self;
    cvc.delegate = self;
    cvc.scrollTopAnimationable = NO;
    [self.view addSubview:cvc.view];
    [self addChildViewController:cvc];
}

-(BHBCardHeaderView *)cardViewControllerCustomHeaderView{
    BHBCardHeaderView * headerView = [[BHBCardHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 344)];
    UIImageView * topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 344)];
    topView.contentMode = UIViewContentModeScaleAspectFill;
    topView.image = [UIImage imageNamed:@"1"];
    topView.clipsToBounds = YES;
    [headerView addSubview:topView];
    return headerView;
    
}

-(NSArray *)cardViewControllerSubControllers{
    TableViewController * tv = [[TableViewController alloc]init];
    ImageViewController * iv = [[ImageViewController alloc]init];
//    ImageViewController * iv1 =[[ImageViewController alloc]init];
    return @[tv,iv];
}

-(BHBCardSegmentView *)cardViewControllerSegmentView{
    BHBCardSegmentView * seView = [[BHBCardSegmentView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49)];
    BHBCardSegmentItem * item1 = [[BHBCardSegmentItem alloc]initWithCustomView:nil];
    item1.title = @"表格";
    BHBCardSegmentItem * item2 = [[BHBCardSegmentItem alloc]init];
    item2.title = @"美女";
    BHBCardSegmentItem * item3 = [[BHBCardSegmentItem alloc]init];
    item3.title = @"滚动";
    seView.items = @[item1,item2];
    return seView;
}

-(void)cardViewHeaderView:(BHBCardHeaderView *)headerView DidDisplayOrNot:(BOOL)isDisplay{
    if(isDisplay)
        NSLog(@"显示headerFrame:%@",NSStringFromCGRect(headerView.frame));
    else{
        NSLog(@"header出屏幕");
    }
}
@end
