//
//  UICollectionViewAdjustHeightLayout.m
//  daydays
//
//  Created by bihongbo on 15/11/27.
//  Copyright © 2015年 daydays. All rights reserved.
//

#import "UICollectionViewAdjustHeightLayout.h"

@implementation UICollectionViewAdjustHeightLayout

-(CGSize)collectionViewContentSize{
    CGSize size = [super collectionViewContentSize];
    
    if (size.height < self.collectionView.frame.size.height) {
        size.height = self.collectionView.frame.size.height;
    }
    
    return size;
    
}

@end
