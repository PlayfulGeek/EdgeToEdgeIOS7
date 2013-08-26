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
    NSMutableArray *_observations;
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
    } else {
        NSAssert(singleton, @"should initWithCoder before requesting shared instance without coder");
    }
    return singleton;
}

- (void)update {
    UIScrollView *scrollView = ([[_viewController view] isKindOfClass:[UIScrollView class]] ? (UIScrollView *)[_viewController view] : nil);
    _contentInsetLabel.text = (scrollView
                               ? [NSString stringWithFormat:@"content inset: %.1f %.1f", scrollView.contentInset.top, scrollView.contentInset.bottom]
                               : @"content inset: (not scroll view)");
    
    _automaticallyAdjustsScrollViewInsetsSwitch.on = _viewController.automaticallyAdjustsScrollViewInsets;
    
    _topLayoutGuideLabel.text = [NSString stringWithFormat:@"top layout guide: %.1f", _viewController.topLayoutGuide.length];
    _bottomLayoutGuideLabel.text = [NSString stringWithFormat:@"bottom layout guide: %.1f", _viewController.bottomLayoutGuide.length];
    
    _edgesForExtendedLayoutTopSwitch.on = _viewController.edgesForExtendedLayout & UIRectEdgeTop;
    _edgesForExtendedLayoutBottomSwitch.on = _viewController.edgesForExtendedLayout & UIRectEdgeBottom;
}

- (void)bindViewController:(UIViewController *)viewController {
    [self removeObservations];
    
    _viewController = viewController;
    [self updateAndLogViewControllerHierarchyWithReason:@"leaf view controller bound"];
    
    [self observeViewController:_viewController];
    if ([[_viewController view] isKindOfClass:[UIScrollView class]]) {
        [self observeScrollView:(UIScrollView *)[_viewController view]];
    }
}

- (void)observeViewController:(UIViewController *)viewController {
    [_observations addObject:
     [KVOBlock addObserverForKeyPath:@"automaticallyAdjustsScrollViewInsets" ofObject:viewController withOptions:0 usingBlock:^(NSObject *object, NSString *keyPath, NSDictionary *change) {
        
        [self relayoutUpdateAndLogViewControllerHierarchyWithReason:@"auto-adjust scroll insets set"];
    }]];
    
    // [layoutGuides not KVC]
    
    [_observations addObject:
     [KVOBlock addObserverForKeyPath:@"edgesForExtendedLayout" ofObject:viewController withOptions:0 usingBlock:^(NSObject *object, NSString *keyPath, NSDictionary *change) {
        
        [self relayoutUpdateAndLogViewControllerHierarchyWithReason:@"edges for extended layout set"];
    }]];
}

- (void)observeScrollView:(UIScrollView *)scrollView {
    [_observations addObject:
     [KVOBlock addObserverForKeyPath:@"contentInset" ofObject:scrollView withOptions:0 usingBlock:^(NSObject *object, NSString *keyPath, NSDictionary *change) {
        
        [self relayoutUpdateAndLogViewControllerHierarchyWithReason:@"content inset set"];
    }]];
}

- (void)removeObservations {
    for (id observation in _observations) {
        [KVOBlock removeObservation:observation];
    }
    _observations = [NSMutableArray array];
}

- (IBAction)automaticallyAdjustsScrollViewInsetsSwitchSet:(id)sender {
    _viewController.automaticallyAdjustsScrollViewInsets = _automaticallyAdjustsScrollViewInsetsSwitch.on;
}

- (IBAction)edgesForExtendedLayoutSwitchSet:(id)sender {
    UIRectEdge edges = _viewController.edgesForExtendedLayout;
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
    _viewController.edgesForExtendedLayout = edges;
}

- (void)relayoutUpdateAndLogViewControllerHierarchyWithReason:(NSString *)reason {
    [[_viewController parentViewController].view setNeedsUpdateConstraints];
    [[_viewController parentViewController].view updateConstraintsIfNeeded];
    [[_viewController parentViewController].view setNeedsLayout];
    [self performSelector:@selector(updateAndLogViewControllerHierarchyWithReason:) withObject:reason afterDelay:0.1]; // after re-laid out
}

- (void)updateAndLogViewControllerHierarchyWithReason:(NSString *)reason {
    [self update];
    
    NSLog(@"\n\n%@; frame=%@", reason, NSStringFromCGRect([_viewController view].frame));
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
              viewController.topLayoutGuide.length, viewController.bottomLayoutGuide.length,
              viewController.automaticallyAdjustsScrollViewInsets?@"YES":@"NO",
              edgesForExtendedLayoutText);
    } toViewControllerAndAncestors:_viewController];
}

- (void)apply:(void (^)(UIViewController *viewController))block toViewControllerAndAncestors:(UIViewController *)viewController {
    if (viewController.parentViewController) {
        [self apply:block toViewControllerAndAncestors:viewController.parentViewController];
    }
    block(viewController);
}

@end
