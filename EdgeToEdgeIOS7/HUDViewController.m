//
//  HUDViewController.m
//  EdgeToEdgeIOS7
//
//  Created by Dan Craft on 8/23/13.
//  Copyright (c) 2013 955 Dreams. All rights reserved.
//

#import "HUD.h"
#import "HUDViewController.h"

@interface HUDViewController ()

@property (weak, nonatomic) IBOutlet HUD *hud;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hudXConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hudYConstraint;

@end

@implementation HUDViewController {
}

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

@end
