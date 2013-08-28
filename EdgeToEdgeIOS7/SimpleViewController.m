//
//  ViewController.m
//  EdgeToEdgeIOS7
//
//  Created by Dan Craft on 8/16/13.
//  Copyright (c) 2013 955 Dreams. All rights reserved.
//

#import "HUD.h"
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
    // re-layout seems to be required for bottom extended edge to have effect when switching back to this (when a non-scroll view); is this a bug in the tab bar controller?
    [[self parentViewController].view setNeedsLayout];
    NSLog(@"\n\nview controller hierarchy");
    UIViewController *vc = self;
    while (vc) {
        NSLog(@"%@", vc);
        vc = vc.parentViewController;
    }
    
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    BOOL adjusts = [super automaticallyAdjustsScrollViewInsets];
    NSLog(@"%@ automaticallyAdjustsScrollViewInsets => %@", NSStringFromClass([self class]), adjusts?@"YES":@"NO");
    return adjusts;
}

- (IBAction)offsetFirstScrollViewYSwitchSet:(UISwitch *)sender {
    self.firstScrollViewYConstraint.constant = sender.on ? 25 : 0;
    self.firstScrollViewYLabel.text = [NSString stringWithFormat:@"y: %.0f", self.firstScrollViewYConstraint.constant];
}

@end
