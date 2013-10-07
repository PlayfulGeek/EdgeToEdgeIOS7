//
//  HUDViewController.m
//  EdgeToEdgeIOS7
//
//  Created by Dan Craft on 8/23/13.
//  Copyright (c) 2013 955 Dreams. All rights reserved.
//

#import "HUD.h"
#import "HUDViewController.h"
#import "Logging.h"

@interface HUDViewController ()
@property (weak, nonatomic) IBOutlet HUD *hud;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hudXConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hudYConstraint;
@end

@implementation HUDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIPanGestureRecognizer *draggingGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDraggingGesture:)];
    [self.hud addGestureRecognizer:draggingGestureRecognizer];
}

- (void)handleDraggingGesture:(UIPanGestureRecognizer *)draggingGestureRecognizer {
    if (draggingGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [draggingGestureRecognizer translationInView:self.view];
        CGFloat maxX = CGRectGetMaxX(self.view.bounds) - CGRectGetWidth(self.hud.frame);
        CGFloat maxY = CGRectGetMaxY(self.view.bounds) - CGRectGetHeight(self.hud.frame);
        self.hudXConstraint.constant = MAX(0, MIN(self.hudXConstraint.constant + translation.x, maxX));
        self.hudYConstraint.constant = MAX(0, MIN(self.hudYConstraint.constant + translation.y, maxY));
        [draggingGestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    }
}

#pragma mark - Status Bar/Overlay

-(UIViewController *)childViewControllerForStatusBarHidden {
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
