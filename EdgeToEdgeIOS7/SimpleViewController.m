//
//  ViewController.m
//  EdgeToEdgeIOS7
//
//  Created by Dan Craft on 8/16/13.
//  Copyright (c) 2013 955 Dreams. All rights reserved.
//

#import "HUD.h"
#import "Logging.h"
#import "SimpleViewController.h"

@interface SimpleViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstScrollViewYConstraint;
@property (weak, nonatomic) IBOutlet UILabel *firstScrollViewYLabel;
@end

@implementation SimpleViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[HUD sharedInstance] bindViewController:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // re-layout seems to be required for bottom extended edge to have effect when switching back to this (when a non-scroll view); is this a bug in the tab bar controller? seems it should lay out whenever it switches children if child has changed its extended edges
    [[self parentViewController].view setNeedsLayout];
    MiscLogIn(@"view controller hierarchy");
    UIViewController *vc = self;
    while (vc) {
        MiscLog(@"%@", vc);
        vc = vc.parentViewController;
    }
    MiscLogOut(@"");
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    BOOL adjusts = [super automaticallyAdjustsScrollViewInsets];
    ScrollInsetPLog(@"=> %@", adjusts?@"YES":@"NO");
    return adjusts;
}

- (UIRectEdge)edgesForExtendedLayout {
    UIRectEdge edges = [super edgesForExtendedLayout];
    ScrollInsetPLog(@"=> %@", [HUD edgesForExtendedLayoutDescription:edges]);
    return edges;
}

- (IBAction)offsetFirstScrollViewYSwitchSet:(UISwitch *)sender {
    self.firstScrollViewYConstraint.constant = sender.on ? 25 : 0;
    self.firstScrollViewYLabel.text = [NSString stringWithFormat:@"y: %.0f", self.firstScrollViewYConstraint.constant];
}

#pragma mark - Status Bar/Overlay

-(UIViewController *)childViewControllerForStatusBarHidden {
    UIViewController *statusBarHiddenAndUpdateAnimationDelegate = [super childViewControllerForStatusBarHidden];
    StatusBarPLog(@"=> %@", statusBarHiddenAndUpdateAnimationDelegate);
    return statusBarHiddenAndUpdateAnimationDelegate;
}

- (BOOL)prefersStatusBarHidden {
    BOOL statusOverlayHidden = [[HUD sharedInstance] statusOverlayHidden];
    StatusBarPLog(@"=> %@", statusOverlayHidden?@"YES":@"NO");
    return statusOverlayHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    StatusBarPLog(@"=> UIStatusBarAnimationSlide");
    return UIStatusBarAnimationSlide; // called but not having effect; what's missing?
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
