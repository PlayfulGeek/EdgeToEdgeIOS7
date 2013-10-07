//
//  ContainerViewController.m
//  EdgeToEdgeIOS7
//
//  Created by Dan Craft on 10/4/13.
//  Copyright (c) 2013 955 Dreams. All rights reserved.
//

#import "ContainerViewController.h"
#import "Logging.h"

@interface ContainerViewController ()

@end

@implementation ContainerViewController

/**
 delegate status overlay control to [selected] child view controller?

 if status overlay, extend top banner to make room at the top for overlay
 
 
*/

#pragma mark - Status Bar/Overlay

- (UIViewController *)childViewControllerForStatusBarHidden {

    // (NOTE: It turns out this method is NOT responsible for asking the child view controller for its childViewControllerForStatusBarHidden.  External mechanism continues down the chain until nil is returned, then uses that view controller.)
    // StatusBarPLogIn(@"");
    // UIViewController *currentChildViewController = self.childViewControllers[0];
    // UIViewController *statusBarHiddenAndUpdateAnimationDelegate = [currentChildViewController childViewControllerForStatusBarHidden];
    // if (!statusBarHiddenAndUpdateAnimationDelegate) {
    //     statusBarHiddenAndUpdateAnimationDelegate = currentChildViewController;
    // }
    // StatusBarPLogOut(@"=> %@", statusBarHiddenAndUpdateAnimationDelegate);

    UIViewController *currentChildViewController = self.childViewControllers[0];
    UIViewController *statusBarHiddenAndUpdateAnimationDelegate = currentChildViewController;
    StatusBarPLog(@"=> %@", statusBarHiddenAndUpdateAnimationDelegate);
    return statusBarHiddenAndUpdateAnimationDelegate;
}

- (BOOL)prefersStatusBarHidden {
    StatusBarPLog(@"should not be called as childViewControllerForStatusBarHidden delegates this to its current child view controller");
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    StatusBarPLog(@"should not be called as childViewControllerForStatusBarHidden (sic) delegates this to its current child view controller");
    return UIStatusBarAnimationSlide;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    
    // (See note in childViewControllerForStatusBarHidden.)
    
    UIViewController *currentChildViewController = self.childViewControllers[0];
    UIViewController *statusBarStyleDelegate = currentChildViewController;
    StatusBarPLog(@"=> %@", statusBarStyleDelegate);
    return statusBarStyleDelegate;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    StatusBarPLog(@"should not be called as childViewControllerForStatusBarStyle delegates this to its current child view controller");
    return UIStatusBarStyleDefault;
}



@end
