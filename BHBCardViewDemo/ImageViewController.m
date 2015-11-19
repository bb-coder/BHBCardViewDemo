//
//  ImageViewController.m
//  BHBCardViewDemo
//
//  Created by bihongbo on 15/11/16.
//  Copyright © 2015年 bihongbo. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@property (nonatomic,strong) UIScrollView * scrollView;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.scrollView];
    int num = 4;
    for (int i = 0; i < num; i ++) {
        
        UIImageView * iv = [[UIImageView alloc]initWithFrame:self.view.bounds];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.clipsToBounds = YES;
        iv.frame = self.view.bounds;
        CGRect frame = iv.frame;
        frame.origin.y = i * self.view.bounds.size.height;
        iv.frame = frame;
        iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",1 + arc4random() % 6]];
        [self.scrollView addSubview:iv];
        
    }
    
    self.scrollView.contentSize = CGSizeMake(0, num * self.view.bounds.size.height);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
