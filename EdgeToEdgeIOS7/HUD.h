//
//  HUD.h
//  EdgeToEdgeIOS7
//
//  Created by Dan Craft on 8/21/13.
//  Copyright (c) 2013 955 Dreams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUD : UIView

+ (HUD *)sharedInstance;

- (void)clear;

- (void)bindScrollView:(UIScrollView *)scrollView;
- (void)bindViewController:(UIViewController *)viewController;

@end
