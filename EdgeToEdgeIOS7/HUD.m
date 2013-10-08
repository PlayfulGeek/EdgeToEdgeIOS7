//
//  HUD.m
//  EdgeToEdgeIOS7
//
//  Created by Dan Craft on 8/21/13.
//  Copyright (c) 2013 955 Dreams. All rights reserved.
//

#import "HUD.h"
#import "KVOBlock.h"
#import "Logging.h"

@interface HUD ()
@property (weak, nonatomic) IBOutlet UILabel *contentInsetLabel;
@property (weak, nonatomic) IBOutlet UISwitch *automaticallyAdjustsScrollViewInsetsSwitch;
@property (weak, nonatomic) IBOutlet UILabel *topLayoutGuideLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLayoutGuideLabel;
@property (weak, nonatomic) IBOutlet UISwitch *edgesForExtendedLayoutTopSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *edgesForExtendedLayoutBottomSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *statusOverlayHiddenSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *navigationBarHiddenSwitch;
@end

@implementation HUD {
    NSMutableArray *_observations;
    UIViewController *_viewController;
    UIScrollView *_scrollViewOrNil;
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
    _contentInsetLabel.text = (_scrollViewOrNil
                               ? [NSString stringWithFormat:@"top: %.0f, bottom: %.0f", _scrollViewOrNil.contentInset.top, _scrollViewOrNil.contentInset.bottom]
                               : @"(no scroll view)");
    
    _automaticallyAdjustsScrollViewInsetsSwitch.on = _viewController.automaticallyAdjustsScrollViewInsets;
    
    _topLayoutGuideLabel.text = [NSString stringWithFormat:@"top layout guide: %.0f", _viewController.topLayoutGuide.length];
    _bottomLayoutGuideLabel.text = [NSString stringWithFormat:@"bottom layout guide: %.0f", _viewController.bottomLayoutGuide.length];
    
    _edgesForExtendedLayoutTopSwitch.on = _viewController.edgesForExtendedLayout & UIRectEdgeTop;
    _edgesForExtendedLayoutBottomSwitch.on = _viewController.edgesForExtendedLayout & UIRectEdgeBottom;
    
    if ([_viewController isKindOfClass:[UINavigationController class]]) {
        _navigationBarHiddenSwitch.on = ((UINavigationController *)_viewController).navigationBarHidden;
    }
}

- (void)bindViewController:(UIViewController *)viewController {
    [self removeObservations];
    
    _viewController = viewController;
    _scrollViewOrNil = [self firstScrollViewInView:_viewController.view];
    [self performSelector:@selector(updateAndLogViewControllerHierarchyWithReason:) withObject:@"leaf view controller bound" afterDelay:0];
    
    [self observeViewController:_viewController];
    if (_scrollViewOrNil) {
        [self observeScrollView:_scrollViewOrNil];
    }
}

- (UIScrollView *)firstScrollViewInView:(UIView *)view { // nil if none; [TODO: check whether iOS VCs use depth first]
    if ([view isKindOfClass:[UIScrollView class]]) {
        return (UIScrollView *)view;
    }
    for (UIView *subview in [view subviews]) {
        UIScrollView *firstScrollViewInSubviews = [self firstScrollViewInView:subview];
        if (firstScrollViewInSubviews) {
            return firstScrollViewInSubviews;
        }
    }
    return nil;
}

- (void)observeViewController:(UIViewController *)viewController {
    [_observations addObject:
     [KVOBlock addObserverForKeyPath:@"automaticallyAdjustsScrollViewInsets" ofObject:viewController withOptions:0 usingBlock:^(NSObject *object, NSString *keyPath, NSDictionary *change) {
        
        [self layoutUpdateAndLogViewControllerHierarchyWithReason:@"auto-adjust scroll insets set"];
    }]];
    
    // (layoutGuides appear not to be KVC)
    
    [_observations addObject:
     [KVOBlock addObserverForKeyPath:@"edgesForExtendedLayout" ofObject:viewController withOptions:0 usingBlock:^(NSObject *object, NSString *keyPath, NSDictionary *change) {
        
        [self layoutUpdateAndLogViewControllerHierarchyWithReason:@"edges for extended layout set"];
    }]];
}

- (void)observeScrollView:(UIScrollView *)scrollView {
    [_observations addObject:
     [KVOBlock addObserverForKeyPath:@"contentInset" ofObject:scrollView withOptions:0 usingBlock:^(NSObject *object, NSString *keyPath, NSDictionary *change) {
        
        [self layoutUpdateAndLogViewControllerHierarchyWithReason:@"content inset set"];
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

- (IBAction)statusOverlayHiddenSwitchSet:(id)sender {
    [_viewController setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)statusOverlayHidden {
    return self.statusOverlayHiddenSwitch.on;
    // note: in UINavigationController, hiding the status overlay and not extending the bottom edge causes an extra 49pt bar to appear atop the tab bar; possibly, the nav controller is not implemented to be within another container view controller, so doing its own, absolute calculations for the bottom of the view (bottom guide is zero)
}

- (BOOL)navigationBarHidden {
    return self.navigationBarHiddenSwitch.on;
}

- (IBAction)navigationBarHiddenSwitchSet:(id)sender {
    static NSString *const key = @"navigationBarHidden";
    [self willChangeValueForKey:key];
    [self didChangeValueForKey:key];
}

//+ (NSSet *)keyPathsForValuesAffectingNavigationBarHidden {
//    return [NSSet setWithObject:@"navigationBarHiddenSwitch.on"];
//}

- (void)layoutUpdateAndLogViewControllerHierarchyWithReason:(NSString *)reason {
    //[[_viewController parentViewController].view setNeedsUpdateConstraints];
    [[_viewController parentViewController].view setNeedsLayout];
    [self performSelector:@selector(updateAndLogViewControllerHierarchyWithReason:) withObject:reason afterDelay:0.1]; // after re-laid out
}

- (void)updateAndLogViewControllerHierarchyWithReason:(NSString *)reason {
    [self update];
    
    MiscLogIn(@"%@; frame=%@", reason, NSStringFromCGRect([_viewController view].frame));
    [self applyBlock:^(UIViewController *viewController) {
        
        NSMutableString *message = [NSMutableString stringWithString:NSStringFromClass([viewController class])];
        [message appendFormat:@", layout guide top=%.1f bottom=%.1f", viewController.topLayoutGuide.length, viewController.bottomLayoutGuide.length];
        [message appendFormat:@", auto-adjusts scroll insets=%@", viewController.automaticallyAdjustsScrollViewInsets?@"YES":@"NO"];
        [message appendFormat:@", edges for extended layout=%@", [HUD edgesForExtendedLayoutDescription:viewController.edgesForExtendedLayout]];
        if (_scrollViewOrNil) {
            [message appendFormat:@", content inset top=%.1f bottom=%.1f left=%.1f right=%.1f", _scrollViewOrNil.contentInset.top, _scrollViewOrNil.contentInset.bottom, _scrollViewOrNil.contentInset.left, _scrollViewOrNil.contentInset.right];
        }
        MiscLog(@"%@", message);
    } toViewControllerAndAncestors:_viewController];
    MiscLogOut(@"");
}

+ (NSString *)edgesForExtendedLayoutDescription:(UIRectEdge)edges {
    NSMutableString *description = [NSMutableString string];
    if (edges & UIRectEdgeTop) {
        [description appendString:@"top"];
    }
    if (edges & UIRectEdgeBottom) {
        if (description.length)
            [description appendString:@" "];
        [description appendString:@"bottom"];
    }
    if (edges & UIRectEdgeLeft) {
        if (description.length)
            [description appendString:@" "];
        [description appendString:@"left"];
    }
    if (edges & UIRectEdgeRight) {
        if (description.length)
            [description appendString:@" "];
        [description appendString:@"right"];
    }
    return [NSString stringWithString:description];
}

- (void)applyBlock:(void (^)(UIViewController *viewController))block toViewControllerAndAncestors:(UIViewController *)viewController {
    if (viewController.parentViewController) {
        [self applyBlock:block toViewControllerAndAncestors:viewController.parentViewController];
    }
    block(viewController);
}

@end
