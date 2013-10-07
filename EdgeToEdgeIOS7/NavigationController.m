//
//  NavigationController.m
//  EdgeToEdgeIOS7
//
//  Created by Dan Craft on 10/4/13.
//  Copyright (c) 2013 955 Dreams. All rights reserved.
//

#import "Logging.h"
#import "NavigationController.h"

@implementation NavigationController

#pragma mark - Status Bar/Overlay

-(UIViewController *)childViewControllerForStatusBarHidden {
    UIViewController *statusBarHiddenAndUpdateAnimationDelegate = [super childViewControllerForStatusBarHidden];
    StatusBarPLog(@"=> %@", statusBarHiddenAndUpdateAnimationDelegate);
    return statusBarHiddenAndUpdateAnimationDelegate;
}

- (BOOL)prefersStatusBarHidden {
    StatusBarPLog(@"should not be called as childViewControllerForStatusBarHidden delegates this to its current child view controller");
    return [super prefersStatusBarHidden];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    StatusBarPLog(@"should not be called as childViewControllerForStatusBarHidden (sic) delegates this to its current child view controller");
    return [super preferredStatusBarUpdateAnimation];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    UIViewController *statusBarStyleDelegate = [super childViewControllerForStatusBarStyle];
    StatusBarPLog(@"=> %@", statusBarStyleDelegate);
    return statusBarStyleDelegate;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    StatusBarPLog(@"should not be called as childViewControllerForStatusBarStyle delegates this to its current child view controller");
    return [super preferredStatusBarStyle];
}

@end
