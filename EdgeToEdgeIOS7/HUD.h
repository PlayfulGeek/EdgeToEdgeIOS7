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

- (void)bindViewController:(UIViewController *)viewController;

@property (nonatomic, readonly) BOOL statusOverlayHidden;

@property (nonatomic, readonly) BOOL navigationBarHidden;

+ (NSString *)edgesForExtendedLayoutDescription:(UIRectEdge)edges;

@end
