//
//  RowsViewController.m
//  EdgeToEdgeIOS7
//
//  Created by Dan Craft on 8/21/13.
//  Copyright (c) 2013 955 Dreams. All rights reserved.
//

#import "Cell.h"
#import "HUD.h"
#import "Logging.h"
#import "RowsViewController.h"

@interface RowsViewController ()
@end

@implementation RowsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[HUD sharedInstance] bindViewController:self];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TestCell" forIndexPath:indexPath];
    cell.cellNumber = indexPath.row + 1;
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//}

#pragma mark - Status Bar/Overlay

-(UIViewController *)childViewControllerForStatusBarHidden {
    UIViewController *statusBarHiddenAndUpdateAnimationDelegate = [super childViewControllerForStatusBarHidden];
    StatusBarPLog(@"=> %@", statusBarHiddenAndUpdateAnimationDelegate);
    return statusBarHiddenAndUpdateAnimationDelegate;
}

- (BOOL)prefersStatusBarHidden {
    BOOL statusOverlayHidden = [HUD sharedInstance].statusOverlayHidden;
    StatusBarPLog(@"=> %@", statusOverlayHidden?@"YES":@"NO");
    return statusOverlayHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    StatusBarPLog(@"=> UIStatusBarAnimationSlide");
    return UIStatusBarAnimationSlide; // called but not having effect; what's missing? (APPLE)
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    UIViewController *statusBarStyleDelegate = [super childViewControllerForStatusBarStyle];
    StatusBarPLog(@"=> %@", statusBarStyleDelegate);
    return statusBarStyleDelegate;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    StatusBarPLog(@"=> UIStatusBarStyleDefault");
    return UIStatusBarStyleDefault;
}

@end
