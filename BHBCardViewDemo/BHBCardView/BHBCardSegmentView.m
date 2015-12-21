//
//  BHBCardSegmentView.m
//  BHBCardViewDemo
//
//  Created by bihongbo on 15/11/13.
//  Copyright © 2015年 bihongbo. All rights reserved.
//

#import "BHBCardSegmentView.h"

@interface BHBCardSegmentView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView * contentView;

@property (nonatomic,strong) UIView * lineView;

@property (nonatomic,weak) BHBCardSegmentItem * selectedItem;

@end

@implementation BHBCardSegmentView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        self.contentView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        self.contentView.delegate = self;
        self.contentView.dataSource = self;
        self.contentView.showsHorizontalScrollIndicator = NO;
        self.contentView.showsVerticalScrollIndicator = NO;
        self.contentView.bounces = NO;
        [self addSubview:self.contentView];
        self.itemInset = UIEdgeInsetsMake(0, 55, 0, 40);
        
        self.showBottomLine = YES;
        self.isAutoLineWidth = YES;
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = [UIColor colorWithRed:0 green:180/255.0 blue:89/255.0 alpha:1];
        [self addSubview:self.lineView];
        _currentIndex = 0;
    }
    return self;
}

- (void)setShowBottomLine:(BOOL)showBottomLine{
    _showBottomLine = showBottomLine;
    if (_showBottomLine) {
        self.lineView.hidden = NO;
    }else{
        self.lineView.hidden = YES;
    }
}

- (void)setItems:(NSArray<BHBCardSegmentItem *> *)items{
    
    _items = items;
    
    for (BHBCardSegmentItem * item in items) {
        if (CGSizeEqualToSize(item.size, CGSizeZero)) {
            item.size = CGSizeMake((self.frame.size.width - self.itemInset.left - self.itemInset.right) / items.count, self.frame.size.height);
        }
    }
    
    if (items > 0) {
        items[_currentIndex].selected = YES;
        self.selectedItem = items[0];
        if(!self.isAutoLineWidth){
        self.lineView.frame = CGRectMake(self.itemInset.left, items[_currentIndex].size.height - 3, items[_currentIndex].size.width, 3);
        }
        else{
        self.lineView.frame = CGRectMake(self.itemInset.left + (items[_currentIndex].size.width - items[_currentIndex].contentFrame.size.width - 40)/2, items[_currentIndex].size.height - 3, items[_currentIndex].contentFrame.size.width + 40, 3);
        }
        
    }
    
}

- (void)lineMoveWithIndex:(NSIndexPath *)indexPath{
    [self lineMoveWithIndex:indexPath andAnimation:YES];
}

- (void)lineMoveWithIndex:(NSIndexPath *)indexPath andAnimation:(BOOL)animation{
    UICollectionViewLayoutAttributes * attr = [self.contentView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
    BHBCardSegmentItem * item = self.items[indexPath.item];
    if (animation) {
        [UIView animateWithDuration:.25 animations:^{
            CGRect frame = self.lineView.frame;
            if (self.isAutoLineWidth) {
                frame.size.width = item.contentFrame.size.width + 40;
                frame.origin.x = attr.frame.origin.x + (item.size.width - frame.size.width)/2;
            }else{
                frame.size.width = item.size.width;
                frame.origin.x = attr.frame.origin.x;
            }
            self.lineView.frame = frame;
        }];
    }else{
        CGRect frame = self.lineView.frame;
        if (self.isAutoLineWidth) {
            frame.size.width = item.contentFrame.size.width + 40;
            frame.origin.x = attr.frame.origin.x + (item.size.width - frame.size.width)/2;
        }else{
            frame.size.width = item.size.width;
            frame.origin.x = attr.frame.origin.x;
        }
        self.lineView.frame = frame;
    }

}


-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    [self setselectIndex:currentIndex andAnimation:YES];
}

- (void)setselectIndex:(NSInteger)currentIndex andAnimation:(BOOL)animation{
    
    [self.contentView selectItemAtIndexPath:[NSIndexPath indexPathForItem:currentIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    self.selectedItem.selected = NO;
    BHBCardSegmentItem * item = self.items[currentIndex];
    item.selected = YES;
    self.selectedItem = item;
    if (animation) {
        [self lineMoveWithIndex:[NSIndexPath indexPathForItem:currentIndex inSection:0]];
    }else{
        [self lineMoveWithIndex:[NSIndexPath indexPathForItem:currentIndex inSection:0] andAnimation:NO];
    }
    
}

- (void)setSelectItem:(NSInteger)index{
    _currentIndex = index;
    [self setselectIndex:index andAnimation:NO];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    BHBCardSegmentItem * item = self.items[indexPath.row];
    return item.size;
}



-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return self.itemInset;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    BHBCardSegmentItem * item = self.items[indexPath.item];
    for (UIView *v in cell.contentView.subviews) {
        [v removeFromSuperview];
    }
    [cell.contentView addSubview:item.customView];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self lineMoveWithIndex:indexPath];
    self.selectedItem.selected = NO;
    BHBCardSegmentItem * item = self.items[indexPath.item];
    item.selected = YES;
    self.selectedItem = item;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cardSegmentViewDidSelectIndex:)]) {
        [self.delegate cardSegmentViewDidSelectIndex:indexPath.item];
    }
    
    
}

@end
