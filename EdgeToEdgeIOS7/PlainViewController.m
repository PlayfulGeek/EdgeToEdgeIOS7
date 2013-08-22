//
//  ViewController.m
//  EdgeToEdgeIOS7
//
//  Created by Dan Craft on 8/16/13.
//  Copyright (c) 2013 955 Dreams. All rights reserved.
//

#import "HUD.h"
#import "PlainViewController.h"

@interface PlainViewController ()

@end

@implementation PlainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[HUD sharedInstance] clear];
    [[HUD sharedInstance] bindViewController:self];
}

@end
