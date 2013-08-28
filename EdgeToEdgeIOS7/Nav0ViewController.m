//
//  RowsViewController.m
//  EdgeToEdgeIOS7
//
//  Created by Dan Craft on 8/21/13.
//  Copyright (c) 2013 955 Dreams. All rights reserved.
//

#import "HUD.h"
#import "Nav0Cell.h"
#import "Nav0ViewController.h"

@interface Nav0ViewController ()
@end

@implementation Nav0ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[HUD sharedInstance] bindViewController:self];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Nav0Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TestCell" forIndexPath:indexPath];
    cell.cellNumber = indexPath.row + 1;
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//}

@end
