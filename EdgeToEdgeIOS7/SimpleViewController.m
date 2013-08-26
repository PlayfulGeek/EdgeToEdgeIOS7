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
}

@end
