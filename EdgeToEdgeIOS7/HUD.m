//
//  HUD.m
//  EdgeToEdgeIOS7
//
//  Created by Dan Craft on 8/21/13.
//  Copyright (c) 2013 955 Dreams. All rights reserved.
//

#import "HUD.h"
#import "KVOBlock.h"

@interface HUD ()
@property (weak, nonatomic) IBOutlet UILabel *contentInsetLabel;
@property (weak, nonatomic) IBOutlet UISwitch *automaticallyAdjustsScrollViewInsetsSwitch;
@property (weak, nonatomic) IBOutlet UILabel *topLayoutGuideLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLayoutGuideLabel;
@property (weak, nonatomic) IBOutlet UISwitch *edgesForExtendedLayoutTopSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *edgesForExtendedLayoutBottomSwitch;
@end

@implementation HUD {
    NSMutableArray *_scrollViewObservations;
    NSMutableArray *_viewControllerObservations;
    UIViewController *_viewController;
}

+ (HUD *)sharedInstance {
    return [[HUD alloc] initWithCoder:nil];
}

- (id)initWithCoder:(NSCoder *)coderOrNil {
    static HUD *singleton = nil;
    if (coderOrNil) {
        NSAssert(!singleton, @"should initWithCoder only once");
        self = [super initWithCoder:coderOrNil];
        singleton = self;
        _scrollViewObservations = [NSMutableArray array];
        _viewControllerObservations = [NSMutableArray array];
    } else {
        NSAssert(singleton, @"should initWithCoder before requesting shared instance without coder");
    }
    return singleton;
}

- (void)clear {
    [self bindScrollView:nil];
    [self bindViewController:nil];
}

- (void)bindScrollView:(UIScrollView *)scrollView {
    for (id observation in _scrollViewObservations) {
        [KVOBlock removeObservation:observation];
    }
    [_scrollViewObservations removeAllObjects];
    
    static NSString *title = @"content inset:";
    if (scrollView) {
        [_scrollViewObservations addObject:
         [KVOBlock addObserverForKeyPath:@"contentInset" ofObject:scrollView withOptions:NSKeyValueObservingOptionInitial usingBlock:^(NSObject *object, NSString *keyPath, NSDictionary *change) {
            
            _contentInsetLabel.text = [NSString stringWithFormat:@"%@ %.1f, %.1f",title, scrollView.contentInset.top, scrollView.contentInset.bottom];
        }]];
    } else {
        _contentInsetLabel.text = title;
    }
}

- (void)bindViewController:(UIViewController *)viewController {
    for (id observation in _viewControllerObservations) {
        [KVOBlock removeObservation:observation];
    }
    [_viewControllerObservations removeAllObjects];
    
    _viewController = viewController;
    
    static NSString *topLayoutGuideTitle = @"top layout guide:";
    static NSString *bottomLayoutGuideTitle = @"bottom layout guide:";
    if (viewController) {
        
        _automaticallyAdjustsScrollViewInsetsSwitch.hidden = NO;
        [_viewControllerObservations addObject:
         [KVOBlock addObserverForKeyPath:@"automaticallyAdjustsScrollViewInsets" ofObject:viewController withOptions:NSKeyValueObservingOptionInitial usingBlock:^(NSObject *object, NSString *keyPath, NSDictionary *change) {
            
            _automaticallyAdjustsScrollViewInsetsSwitch.on = viewController.automaticallyAdjustsScrollViewInsets;
            [self logViewControllerHierarchy:viewController reason:@"auto-adjust scroll insets set"];
        }]];
        
        [_viewControllerObservations addObject:
         [KVOBlock addObserverForKeyPath:@"topLayoutGuide" ofObject:viewController withOptions:NSKeyValueObservingOptionInitial usingBlock:^(NSObject *object, NSString *keyPath, NSDictionary *change) {
            
            _topLayoutGuideLabel.text = [NSString stringWithFormat:@"%@ %.1f", topLayoutGuideTitle, _viewController.topLayoutGuide.length];
            [self logViewControllerHierarchy:viewController reason:@"top layout guide set"];
        }]];
        
        [_viewControllerObservations addObject:
         [KVOBlock addObserverForKeyPath:@"bottomLayoutGuide" ofObject:viewController withOptions:NSKeyValueObservingOptionInitial usingBlock:^(NSObject *object, NSString *keyPath, NSDictionary *change) {
            
            _bottomLayoutGuideLabel.text = [NSString stringWithFormat:@"%@ %.1f", bottomLayoutGuideTitle, _viewController.bottomLayoutGuide.length];
            [self logViewControllerHierarchy:viewController reason:@"bottom layout guide set"];
        }]];
        
        _edgesForExtendedLayoutTopSwitch.hidden = NO;
        _edgesForExtendedLayoutBottomSwitch.hidden = NO;
        [_viewControllerObservations addObject:
         [KVOBlock addObserverForKeyPath:@"edgesForExtendedLayout" ofObject:viewController withOptions:NSKeyValueObservingOptionInitial usingBlock:^(NSObject *object, NSString *keyPath, NSDictionary *change) {
            
            _edgesForExtendedLayoutTopSwitch.on = viewController.edgesForExtendedLayout & UIRectEdgeTop;
            _edgesForExtendedLayoutBottomSwitch.on = viewController.edgesForExtendedLayout & UIRectEdgeBottom;
            [self logViewControllerHierarchy:viewController reason:@"edges for extended layout set"];
        }]];
    }
    
    else {
        _automaticallyAdjustsScrollViewInsetsSwitch.hidden = YES;
        _topLayoutGuideLabel.text = topLayoutGuideTitle;
        _bottomLayoutGuideLabel.text = bottomLayoutGuideTitle;
        _edgesForExtendedLayoutTopSwitch.hidden = YES;
        _edgesForExtendedLayoutBottomSwitch.hidden = YES;
    }
}

- (IBAction)automaticallyAdjustsScrollViewInsetsSwitchSet:(id)sender {
    [self apply:^(UIViewController *viewController) {
        viewController.automaticallyAdjustsScrollViewInsets = _automaticallyAdjustsScrollViewInsetsSwitch.on;
    } toViewControllerAndAncestors:_viewController];
}

- (IBAction)edgesForExtendedLayoutSwitchSet:(id)sender {
    [self apply:^(UIViewController *viewController) {
        UIRectEdge edges = viewController.edgesForExtendedLayout;
        if (_edgesForExtendedLayoutTopSwitch.on) {
            edges |= UIRectEdgeTop;
        } else {
            edges &= ~UIRectEdgeTop;
        }
        if (_edgesForExtendedLayoutBottomSwitch.on) {
            edges |= UIRectEdgeBottom;
        } else {
            edges &= ~UIRectEdgeBottom;
        }
        viewController.edgesForExtendedLayout = edges;
    } toViewControllerAndAncestors:_viewController];
}

- (void)logViewControllerHierarchy:(UIViewController *)viewController reason:(NSString *)reason {
    NSLog(@"\n\n%@ frame=%@", reason, NSStringFromCGRect([viewController view].frame));
    [self apply:^(UIViewController *viewController) {
        NSMutableString *edgesForExtendedLayoutText = [NSMutableString string];
        if (viewController.edgesForExtendedLayout & UIRectEdgeTop) {
            [edgesForExtendedLayoutText appendString:@" top"];
        }
        if (viewController.edgesForExtendedLayout & UIRectEdgeBottom) {
            [edgesForExtendedLayoutText appendString:@" bottom"];
        }
        if (viewController.edgesForExtendedLayout & UIRectEdgeLeft) {
            [edgesForExtendedLayoutText appendString:@" left"];
        }
        if (viewController.edgesForExtendedLayout & UIRectEdgeRight) {
            [edgesForExtendedLayoutText appendString:@" right"];
        }
        NSLog(@"%@, guides top=%.1f bottom=%.1f, auto-adjusts scroll insets=%@, edges for extended layout=%@",
              NSStringFromClass([viewController class]),
              _viewController.topLayoutGuide.length, _viewController.bottomLayoutGuide.length,
              viewController.automaticallyAdjustsScrollViewInsets?@"YES":@"NO",
              edgesForExtendedLayoutText);
    } toViewControllerAndAncestors:viewController];
}

- (void)apply:(void (^)(UIViewController *viewController))block toViewControllerAndAncestors:(UIViewController *)viewController {
//    if (viewController.parentViewController) {
//        [self apply:block toViewControllerAndAncestors:viewController.parentViewController];
//    }
    block(viewController);
}

@end
